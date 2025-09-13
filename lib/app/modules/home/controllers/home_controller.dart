import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import '../../../../common/appColors.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../project/controllers/project_controller.dart';
import 'chat_controller.dart';

class HomeController extends GetxController {
  final currentProject = Rxn<ProjectDetail>();

  var selectedMilestone = ''.obs;
  var milestoneTimeDuration = TextEditingController();
  var milestoneBudget = TextEditingController();

  void updateProjectMilestone(String projectId) {
    // Logic to refresh project data, e.g., fetch updated project from API
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final role = await BaseClient.getStoredRole();
    if (role == 'borrower') {
      loadContextFromPrefs();
    } else if (role == 'private_lender') {
    }
  }

  Future<void> loadContextFromPrefs() async {
    try {
      final project = await ProjectPrefs.getCurrentProject();
      currentProject.value = project;
      debugPrint('===========================HomeController: Loaded project: ${project?.name}');
      debugPrint('===========================HomeController: Loaded project: ${currentProject.value?.milestones[2].status}');
    } catch (e) {
      debugPrint('💥💥💥 HomeController: Error loading project context: $e');
    }
  }

  Future<void> startMilestones() async {
    try {
      // Find the milestone that matches the selected milestone name
      final selectedMilestoneId = currentProject.value?.milestones
          .firstWhere(
            (m) => m.name == selectedMilestone.value,
        orElse: () => throw Exception('No matching milestone found'),
      )
          .id;

      // Validate inputs
      if (selectedMilestoneId == null) {
        kSnackBar(
          title: 'Warning',
          message: 'Please select a valid milestone.',
          bgColor: AppColors.snackBarWarning,
        );
        return;
      }

      if (milestoneTimeDuration.text.isEmpty || milestoneBudget.text.isEmpty) {
        kSnackBar(
          title: 'Warning',
          message: 'Please enter both time duration and budget.',
          bgColor: AppColors.snackBarWarning,
        );
        return;
      }

      // Parse text inputs to integers
      int? duration;
      int? budget;
      try {
        duration = int.parse(milestoneTimeDuration.text);
        budget = int.parse(milestoneBudget.text);
      } catch (e) {
        kSnackBar(
          title: 'Warning',
          message: 'Please enter valid integer values for duration and budget.',
          bgColor: AppColors.snackBarWarning,
        );
        return;
      }

      // Ensure positive values
      if (duration <= 0 || budget <= 0) {
        kSnackBar(
          title: 'Warning',
          message: 'Duration and budget must be positive integers.',
          bgColor: AppColors.snackBarWarning,
        );
        return;
      }

      final milestoneData = {
        'milestone_id': selectedMilestoneId,
        'duration': duration,
        'budget': budget,
      };

      debugPrint('Starting milestone with data: $milestoneData');

      final response = await BaseClient.postRequest(
        api: Api.startMilestone(currentProject.value?.id),
        body: jsonEncode(milestoneData),
        headers: BaseClient.authHeaders(),
      );

      await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.startMilestone(currentProject.value?.id),
          body: jsonEncode(milestoneData),
          headers: BaseClient.authHeaders(),
        ),
      );

      debugPrint('Milestone started successfully. Fetching updated project details...');

      // Step 1: Fetch project details
      await Get.find<ProjectController>().fetchProjectDetails(currentProject.value!.id);

      // Step 2: Check if project details are loaded
      final projectDetail = Get.find<ProjectController>().projectDetail.value;
      if (projectDetail == null) {
        kSnackBar(
          title: 'Error',
          message: 'Failed to load project details.',
          bgColor: AppColors.snackBarWarning,
        );
        return;
      }

      // Step 3: Save context to preferences
      await ProjectPrefs.saveContext(projectDetail: projectDetail);

      // Step 4: Load context from preferences
      loadContextFromPrefs();

      // Step 5: Navigate to DashboardView
      Get.to(() => const DashboardView());
    } catch (e, stackTrace) {
      debugPrint('Error in startMilestones: $e\nStackTrace: $stackTrace');
      kSnackBar(
        title: 'Error',
        message: 'Failed to start milestone. Please try again.',
        bgColor: AppColors.snackBarWarning,
      );
    }
  }

  // Method to manually refresh context
  Future<void> refreshContext() async {
    await loadContextFromPrefs();
  }
}