import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:loan_site/app/modules/project/views/set_milestone_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../../data/models/project.dart';
import '../../../../common/widgets/custom_snackbar.dart';

class ProjectDetail {
  final int id;
  final String name;
  final String type;
  final String manager;
  final String location;
  final ProjectProgress progress;
  final List<ProjectMilestone> milestones;
  final List<ProjectUpdate> recentUpdates;

  ProjectDetail({
    required this.id,
    required this.name,
    required this.type,
    required this.manager,
    required this.location,
    required this.progress,
    required this.milestones,
    required this.recentUpdates,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> j) {
    try {
      return ProjectDetail(
        id: (j['project_id'] as num?)?.toInt() ?? 0,
        name: j['project_name'] as String? ?? '',
        type: j['project_type'] as String? ?? '',
        manager: j['project_manager'] as String? ?? '',
        location: j['project_location'] as String? ?? '',
        progress: ProjectProgress.fromJson(j['project_progress'] as Map<String, dynamic>? ?? {}),
        milestones: (j['milestones'] as List<dynamic>? ?? [])
            .map((e) => ProjectMilestone.fromJson(e as Map<String, dynamic>))
            .toList(),
        recentUpdates: (j['project_recent_updates'] as List<dynamic>? ?? [])
            .map((e) => ProjectUpdate.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing ProjectDetail: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
}

class ProjectProgress {
  final double percentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final int completedPhases;
  final int totalPhases;
  final int? duration;
  final int? budget_used;

  ProjectProgress({
    required this.percentage,
    required this.startDate,
    required this.endDate,
    required this.completedPhases,
    required this.totalPhases,
    required this.duration,
    required this.budget_used
  });

  factory ProjectProgress.fromJson(Map<String, dynamic> j) {
    try {
      return ProjectProgress(
        percentage: (j['percentage'] as num?)?.toDouble() ?? 0.0,
        startDate: j['start_date'] != null ? DateTime.tryParse(j['start_date'] as String) : null,
        endDate: j['end_date'] != null ? DateTime.tryParse(j['end_date'] as String) : null,
        completedPhases: (j['completed_phases'] as num?)?.toInt() ?? 0,
        totalPhases: (j['total_phases'] as num?)?.toInt() ?? 0,
        duration: (j['duration'] as num?)?.toInt(),
        budget_used: (j['budget_used'] as num?)?.toInt(),
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing ProjectProgress: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  double get percent0to1 {
    double p = percentage > 0 ? (percentage / 100.0) : _ratio;
    if (p.isNaN) p = 0.0;
    if (p < 0) p = 0.0;
    if (p > 1) p = 1.0;
    return p;
  }

  int get percent100 => (percent0to1 * 100).round();

  int get daysRemaining {
    if (endDate == null) return 0;
    final diff = endDate!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  String fmtDate(DateTime? d) =>
      d == null ? '-' : DateFormat('MMM d, yyyy').format(d);

  double get _ratio =>
      totalPhases > 0 ? (completedPhases / totalPhases) : 0.0;
}

class ProjectMilestone {
  final int id;
  final String name;
  final String status;

  ProjectMilestone({required this.id, required this.name, required this.status});

  factory ProjectMilestone.fromJson(Map<String, dynamic> j) {
    try {
      return ProjectMilestone(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: j['name'] as String? ?? '',
        status: j['status'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing ProjectMilestone: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
}

class ProjectUpdate {
  final String milestoneName;
  final String status;
  final String date;
  final String message;

  ProjectUpdate({
    required this.milestoneName,
    required this.status,
    required this.date,
    required this.message,
  });

  factory ProjectUpdate.fromJson(Map<String, dynamic> j) {
    try {
      return ProjectUpdate(
        milestoneName: j['milestone_name'] as String? ?? '',
        status: j['status'] as String? ?? '',
        date: j['date'] as String? ?? '',
        message: j['message'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing ProjectUpdate: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
}

class ProjectController extends GetxController {
  // Text controllers for project details
  final projectNameController = TextEditingController();
  final projectTypeController = TextEditingController();
  final projectBudgetController = TextEditingController();
  final projectManagerNameController = TextEditingController();
  final projectLocationController = TextEditingController();
  final projectStartDateController = TextEditingController();
  final projectEndDateController = TextEditingController();
  final projectDescriptionController = TextEditingController();

  // Text controllers for permit details
  final permitNumberController = TextEditingController();
  final permitTypeController = TextEditingController();
  final permitIssueDateController = TextEditingController();
  final permitExpireDateController = TextEditingController();

  // Observable for current step
  var currentStep = 1.obs;

  // List to store contractor controllers
  final contractorControllers = <Map<String, TextEditingController>>[].obs;

  // Store selected lender ID
  var selectedLenderId = 0.obs;

  // Store AI-suggested milestones
  var aiSuggestedMilestones = <String>[].obs;

  // Store project ID
  var projectId = 0.obs;

  var projects = <Project>[].obs;

  // Active project detail state
  final isProjectLoading = false.obs;
  final projectError = Rxn<String>();
  final projectDetail = Rxn<ProjectDetail>();

  final activeProjectId = Rxn<int>();

  // Image picker and related observables
  final ImagePicker _picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;
  RxInt currentImageIndex = 0.obs;
  RxBool showImageOverlay = false.obs;
  PageController pageController = PageController();
  final isImageUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    addContractor();
  }

  void ensureProjectLoaded(int projectId) async {
    if (activeProjectId.value != projectId || projectDetail.value == null) {
      activeProjectId.value = projectId;
      await fetchProjectDetails(projectId);
    }
  }

  Future<void> fetchProjectDetails(int id) async {
    try {
      isProjectLoading.value = true;
      projectError.value = null;
      debugPrint('ProjectController: Fetching project details for ID: $id');

      final response = await BaseClient.getRequest(
        api: Api.projectDetails(id),
        headers: BaseClient.authHeaders(),
      );

      final data = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.projectDetails(id),
          headers: BaseClient.authHeaders(),
        ),
      );

      debugPrint('ProjectController: Raw API response: $data');

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: Expected a JSON object');
      }

      projectDetail.value = ProjectDetail.fromJson(data);
      debugPrint('ProjectController: Project details loaded: ${projectDetail.value?.name}');
    } catch (e, stackTrace) {
      debugPrint('ProjectController: Error fetching project details: $e\nStackTrace: $stackTrace');
      projectError.value = 'Failed to fetch project details: $e';
      projectDetail.value = null;
    } finally {
      isProjectLoading.value = false;
    }
  }

  Future<void> fetchProjects({String statusFilter = 'all'}) async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getAllProject,
        headers: BaseClient.authHeaders(),
      );

      final data = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getAllProject,
          headers: BaseClient.authHeaders(),
        ),
      );

      if (data != null) {
        List<Project> projectList = (data as List)
            .map((json) => Project.fromJson(json))
            .toList();

        if (statusFilter != 'all') {
          projectList = projectList
              .where((project) => project.status.toLowerCase() == statusFilter.toLowerCase())
              .toList();
        }

        projects.value = projectList;

        if (projectList.isEmpty) {
          Get.snackbar('Info', 'No $statusFilter projects are available');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch projects');
      }
    } catch (e) {
      print("Error fetching projects: $e");
      Get.snackbar('Error', 'Failed to fetch projects');
    }
  }

  void addContractor() {
    contractorControllers.add({
      'name': TextEditingController(),
      'phone': TextEditingController(),
      'email': TextEditingController(),
      'license': TextEditingController(),
      'details': TextEditingController(),
    });
  }

  void setSelectedLenderId(int lenderId) {
    selectedLenderId.value = lenderId;
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((xfile) => File(xfile.path)));
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    if (currentImageIndex.value >= selectedImages.length &&
        selectedImages.isNotEmpty) {
      currentImageIndex.value = selectedImages.length - 1;
      pageController.jumpToPage(currentImageIndex.value);
    } else if (selectedImages.isEmpty) {
      showImageOverlay.value = false;
    }
  }

  void showImageViewer(int index) {
    currentImageIndex.value = index;
    pageController = PageController(initialPage: index);
    showImageOverlay.value = true;
  }

  void nextImage() {
    if (currentImageIndex.value < selectedImages.length - 1) {
      currentImageIndex.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousImage() {
    if (currentImageIndex.value > 0) {
      currentImageIndex.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void closeImageViewer() {
    showImageOverlay.value = false;
  }

  void showUploadOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Photos',
              style: h3.copyWith(fontSize: 18, color: AppColors.textColor),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImageFromCamera();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.chatCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray5),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: AppColors.clrBlue1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Camera',
                            style: h4.copyWith(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImages();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.chatCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray5),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 30,
                            color: AppColors.clrBlue1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: h4.copyWith(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showWarning(String message, {String title = 'Warning'}) {
    kSnackBar(
      title: title,
      message: message,
      bgColor: AppColors.snackBarWarning,
    );
  }

  Future<void> createProject() async {
    isImageUploading.value = true;
    try {
      // Prepare project data
      final projectData = {
        "name": projectNameController.text,
        "type": projectTypeController.text,
        "location": projectLocationController.text,
        "budget": int.tryParse(projectBudgetController.text) ?? 0,
        "project_manager": projectManagerNameController.text,
        "start_date": projectStartDateController.text,
        "end_date": projectEndDateController.text,
        "description": projectDescriptionController.text,
        "permit_number": permitNumberController.text,
        "permit_type": permitTypeController.text,
        "permit_issued_date": permitIssueDateController.text,
        "permit_expiry_date": permitExpireDateController.text,
      };

      // Prepare contractor data
      final contractorData = contractorControllers
          .map(
            (controller) => {
          "name": controller['name']!.text,
          "email": controller['email']!.text,
          "phone": controller['phone']!.text,
          "address": controller['details']!.text,
          "license_number": controller['license']!.text,
        },
      )
          .toList();

      // Prepare JSON body
      final requestBody = {
        "project": projectData,
        "contractor": contractorData,
      };

      // Send POST request with JSON body
      final response = await BaseClient.postRequest(
        api: Api.createProject,
        headers: BaseClient.authHeaders(),
        body: jsonEncode(requestBody),
      );

      debugPrint("API Hit: ${Api.createProject}");
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);

        if (result['id'] != null) {
          projectId.value = result['id'];
          aiSuggestedMilestones.value = List<String>.from(
            result['ai_suggested_milestones'] ?? [],
          );

          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/auth/tic_icon.svg',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your project has been created successfully!',
                      style: h4.copyWith(
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'OK',
                      onPressed: () {
                        Get.back();
                        Get.to(() => const SetMilestoneView());
                      },
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          );

          // Clear selected images after successful upload
          selectedImages.clear();
        } else {
          Get.snackbar(
            'Error',
            'Failed to create project: Invalid response',
            backgroundColor: AppColors.snackBarWarning,
            colorText: AppColors.textColor,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to create project: ${response.reasonPhrase}',
          backgroundColor: AppColors.snackBarWarning,
          colorText: AppColors.textColor,
        );
      }
    } catch (e) {
      debugPrint("Error creating project: $e");
      Get.snackbar(
        'Error',
        'Failed to create project: $e',
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
      rethrow;
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime(2026, 12, 31),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  void removeContractor(int index) {
    if (index >= 0 && index < contractorControllers.length) {
      contractorControllers[index].forEach((key, controller) {
        controller.dispose();
      });
      contractorControllers.removeAt(index);
      contractorControllers.refresh();
    }
  }

  void reset() {
    projectNameController.clear();
    projectTypeController.clear();
    projectBudgetController.clear();
    projectManagerNameController.clear();
    projectLocationController.clear();
    projectStartDateController.clear();
    projectEndDateController.clear();
    projectDescriptionController.clear();
    permitNumberController.clear();
    permitTypeController.clear();
    permitIssueDateController.clear();
    permitExpireDateController.clear();

    for (var controllerMap in contractorControllers) {
      controllerMap.forEach((key, controller) => controller.dispose());
    }
    contractorControllers.clear();

    selectedImages.clear();
    currentImageIndex.value = 0;
    showImageOverlay.value = false;
    pageController.dispose();

    currentStep.value = 1;
    selectedLenderId.value = 0;
    aiSuggestedMilestones.clear();
    projectId.value = 0;
    projects.clear();
    projectDetail.value = null;
    activeProjectId.value = null;
    isProjectLoading.value = false;
    projectError.value = null;
    isImageUploading.value = false;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class ProjectPrefs {
  static const _kCurrentProject = 'current_project';

  static Future<void> saveContext({required ProjectDetail projectDetail}) async {
    final sp = await SharedPreferences.getInstance();
    final projectJson = jsonEncode({
      "project_id": projectDetail.id,
      'project_name': projectDetail.name,
      'project_type': projectDetail.type,
      'project_manager': projectDetail.manager,
      'project_location': projectDetail.location,
      'project_progress': {
        'percentage': projectDetail.progress.percentage,
        'start_date': projectDetail.progress.startDate?.toIso8601String(),
        'end_date': projectDetail.progress.endDate?.toIso8601String(),
        'completed_phases': projectDetail.progress.completedPhases,
        'total_phases': projectDetail.progress.totalPhases,
        'duration': projectDetail.progress.duration,
        'budget_used': projectDetail.progress.budget_used,
      },
      'milestones': projectDetail.milestones
          .map((m) => {'id': m.id, 'name': m.name, 'status': m.status})
          .toList(),
      'project_recent_updates': projectDetail.recentUpdates
          .map((u) => {
        'milestone_name': u.milestoneName,
        'status': u.status,
        'date': u.date,
        'message': u.message,
      })
          .toList(),
    });
    await sp.setString(_kCurrentProject, projectJson);
    print(' 💥💥💥 ---------------------------->>>> Project saved !');
    print(' 💥💥💥 ---------------------------->>>> $projectJson');
  }

  static Future<ProjectDetail?> getCurrentProject() async {
    final sp = await SharedPreferences.getInstance();
    final projectJson = sp.getString(_kCurrentProject);
    if (projectJson == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(projectJson);
      return ProjectDetail.fromJson(json);
    } catch (e) {
      debugPrint('Error parsing project from SharedPreferences: $e');
      return null;
    }
  }

  static Future<void> clearCurrentProject() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kCurrentProject);
  }
}