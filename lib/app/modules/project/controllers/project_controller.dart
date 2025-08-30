import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loan_site/app/modules/project/views/set_milestone_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';
import '../../../data/models/project.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Add one contractor input field by default
    addContractor();
    fetchProjects();
  }

  // Fetch all projects
  Future<void> fetchProjects() async {
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
        final List<Project> projectList = (data as List)
            .map((json) => Project.fromJson(json))
            .toList();
        projects.value = projectList; // Update the project list

        // Check if the project list is empty
        if (projectList.isEmpty) {
          Get.snackbar('Info', 'No projects are available');
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
}