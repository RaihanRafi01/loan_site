import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/dashboard/views/dashboard_view.dart';
import 'package:loan_site/app/modules/home/controllers/home_controller.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customDropDown.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';

class StartMilestoneView extends GetView<HomeController> {
  const StartMilestoneView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current project from HomeController
    final project = controller.currentProject.value;

    // If no project is available, show an error message
    if (project == null) {
      return Scaffold(
        backgroundColor: AppColors.appBc,
        body: Center(
          child: Text(
            'No project selected',
            style: h3.copyWith(fontSize: 16, color: AppColors.textColor8),
          ),
        ),
      );
    }

    // Filter non-completed milestones for the dropdown
    final availableMilestones = project.milestones
        ?.where((m) => m.status != 'completed')
        ?.map((m) => m.name)
        ?.toList() ??
        [];

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Configure Milestone Phase',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Milestone Phase',
                style: h3.copyWith(fontSize: 16, color: AppColors.textColor8),
              ),
              CustomDropdown(
                labelText: availableMilestones.isEmpty
                    ? 'No milestones available'
                    : 'Select your milestone phase',
                value: controller.selectedMilestone.value.isEmpty
                    ? null
                    : controller.selectedMilestone.value,
                items: availableMilestones,
                onChanged: availableMilestones.isEmpty
                    ? null // Disable dropdown if no milestones
                    : (value) {
                  if (value != null) {
                    controller.selectedMilestone.value = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Select Time Duration',
                style: h3.copyWith(fontSize: 16, color: AppColors.textColor8),
              ),
              CustomTextField(
                labelText: 'Enter time duration (e.g., 30 days)',
                controller: controller.milestoneTimeDuration,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                'Budget',
                style: h3.copyWith(fontSize: 16, color: AppColors.textColor8),
              ),
              CustomTextField(
                labelText: 'Enter budget (e.g., 5000)',
                controller: controller.milestoneBudget,
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: CustomButton(
                  label: 'Done',
                  onPressed: () async {
                    await controller.startMilestones();
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}