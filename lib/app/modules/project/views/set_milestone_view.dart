import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/dashboard/views/dashboard_view.dart';
import 'package:loan_site/app/modules/project/controllers/project_controller.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';

import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class SetMilestoneView extends GetView<ProjectController> {
  const SetMilestoneView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller to manage checkbox states
    final RxList<bool> checkboxStates = List<bool>.filled(controller.aiSuggestedMilestones.length, false).obs;

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        title: Text(
          'Set Milestone',
          style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.appBc,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // List of checkboxes with AI-suggested milestones
            Obx(() => Column(
              children: List.generate(
                controller.aiSuggestedMilestones.length,
                    (index) => Row(
                  children: [
                    Checkbox(
                      value: checkboxStates[index],
                      onChanged: (bool? value) {
                        checkboxStates[index] = value ?? false;
                        checkboxStates.refresh(); // Update UI
                      },
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        controller.aiSuggestedMilestones[index],
                        style: h4.copyWith(color: AppColors.textColor, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 40),
            // Button showing selected count
            Obx(() {
              final selectedCount = checkboxStates.where((e) => e).length;
              return selectedCount > 0
                  ? CustomButton(
                label: 'Selected ($selectedCount) Milestone${selectedCount > 1 ? 's' : ''}',
                onPressed: () {
                  // Call API to save selected milestones
                  saveMilestones(
                    controller.aiSuggestedMilestones
                        .asMap()
                        .entries
                        .where((entry) => checkboxStates[entry.key])
                        .map((entry) => entry.value)
                        .toList(),
                  );
                },
              )
                  : const SizedBox.shrink(); // Hide button if no checkboxes selected
            }),
          ],
        ),
      ),
    );
  }

  // API call to save selected milestones
  Future<void> saveMilestones(List<String> selectedMilestones) async {
    try {
      // Creating the list of milestone objects as per the required format
      final List<Map<String, String>> milestones = selectedMilestones
          .map((milestone) => {"name": milestone})
          .toList();

      final milestoneData = {
        "milestones": milestones,
      };

      final response = await BaseClient.postRequest(
        api: Api.setProjectMilestone(controller.projectId.value), // Replace with actual API endpoint
        body: jsonEncode(milestoneData),
        headers: BaseClient.authHeaders(),
      );

      await BaseClient.handleResponse(response, retryRequest: () => BaseClient.postRequest(
        api: Api.setProjectMilestone(controller.projectId.value),
        body: jsonEncode(milestoneData),
        headers: BaseClient.authHeaders(),
      ));

      // Navigate to DashboardView on success
      Get.offAll(() => const DashboardView());
    } catch (e) {
      debugPrint("Error saving milestones: $e");
    }
  }

}