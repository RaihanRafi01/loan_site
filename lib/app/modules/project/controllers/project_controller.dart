import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loan_site/app/modules/project/views/set_milestone_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../../data/models/project.dart';

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
        id: (j['project_id'] as num?)?.toInt() ?? 0, // Handle int
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
  ////////
  final activeProjectId = Rxn<int>();

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
      // Do not rethrow to avoid breaking the caller
    } finally {
      isProjectLoading.value = false;
    }
  }


  // Fetch all projects
  Future<void> fetchProjects({String statusFilter = 'all'}) async {
    try {
      // Make GET request to fetch projects
      final response = await BaseClient.getRequest(
        api: Api.getAllProject,
        headers: BaseClient.authHeaders(),
      );

      // Handle the response
      final data = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getAllProject,
          headers: BaseClient.authHeaders(),
        ),
      );

      if (data != null) {
        // Map the response to the Project model
        List<Project> projectList = (data as List)
            .map((json) => Project.fromJson(json))
            .toList();

        // Apply status filter
        if (statusFilter != 'all') {
          projectList = projectList
              .where((project) => project.status.toLowerCase() == statusFilter.toLowerCase())
              .toList();
        }

        projects.value = projectList; // Update the project list

        // Check if the project list is empty
        if (projectList.isEmpty) {
          Get.snackbar('Info', 'No $statusFilter projects are available');
        }
      } else {
        // Handle case where data is null
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

  // Method to set the selected lender ID from SelectLenderView
  void setSelectedLenderId(int lenderId) {
    selectedLenderId.value = lenderId;
  }

  // API call to create a project
  Future<void> createProject() async {
    try {
      final projectData = {
        "project": {
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
        },
        "contractor": contractorControllers
            .map(
              (controller) => {
            "name": controller['name']!.text,
            "email": controller['email']!.text,
            "phone": controller['phone']!.text,
            "address": controller['details']!.text,
            // Assuming 'details' maps to 'address'
            "license_number": controller['license']!.text,
          },
        )
            .toList(),
      };

      final response = await BaseClient.postRequest(
        api: Api.createProject,
        body: jsonEncode(projectData),
        headers: BaseClient.authHeaders(),
      );

      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.createProject,
          body: jsonEncode(projectData),
          headers: BaseClient.authHeaders(),
        ),
      );

      if (result['id'] != null) {
        // Store project ID
        projectId.value = result['id'];
        // Store AI-suggested milestones
        aiSuggestedMilestones.value = List<String>.from(
          result['ai_suggested_milestones'] ?? [],
        );

        // Show confirmation dialog
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
                      Get.back(); // Close the dialog
                      // Navigate to SetMilestoneView after dialog is closed
                      Get.to(() => const SetMilestoneView());
                    },
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: true, // Allow dismissing by tapping outside
        );
      } else {
        // Handle case where result['id'] is null
        Get.snackbar(
          'Error',
          'Failed to create project: Invalid response',
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
      rethrow; // Rethrow to allow caller (e.g., SelectLenderController) to handle
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)), // Allow past dates
      lastDate: DateTime(2026, 12, 31),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  void removeContractor(int index) {
    if (index >= 0 && index < contractorControllers.length) {
      // Dispose of the TextEditingControllers to prevent memory leaks
      contractorControllers[index].forEach((key, controller) {
        controller.dispose();
      });
      // Remove the contractor from the list
      contractorControllers.removeAt(index);
      // Update the UI reactively
      contractorControllers.refresh();
    }
  }

  void reset() {
    // Clear text controllers
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

    // Clear contractor controllers
    for (var controllerMap in contractorControllers) {
      controllerMap.forEach((key, controller) => controller.dispose());
    }
    contractorControllers.clear();

    // Reset observables
    currentStep.value = 1;
    selectedLenderId.value = 0;
    aiSuggestedMilestones.clear();
    projectId.value = 0;
    projects.clear();
    projectDetail.value = null;
    activeProjectId.value = null;
    isProjectLoading.value = false;
    projectError.value = null;
  }

}

class ProjectPrefs {
  static const _kCurrentProject = 'current_project';

  static Future<void> saveContext({required ProjectDetail projectDetail}) async {
    final sp = await SharedPreferences.getInstance();
    // Convert ProjectDetail to JSON
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