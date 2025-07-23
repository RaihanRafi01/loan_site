import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/dashboard/views/dashboard_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';

class SetMilestoneView extends GetView {
  const SetMilestoneView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller to manage checkbox states
    final RxList<bool> checkboxStates = [false, false, false, false, false].obs;
    // Default text for checkboxes
    final List<String> milestoneTitles = [
      'Floor Installation',
      'Flooring Materials',
      'Prepare the Surface',
      'Quality Inspection',
      'Final Inspection',
      'Demolition',
      'Electrical Work',
      'Plumbing',
    ];

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
            // List of checkboxes with text
            Obx(() => Column(
              children: List.generate(5, (index) {
                return Row(
                  children: [
                    Checkbox(
                      value: checkboxStates[index],
                      onChanged: (bool? value) {
                        checkboxStates[index] = value ?? false;
                        checkboxStates.refresh(); // Update UI
                      },
                      activeColor: Colors.blue, // Checkbox color
                      checkColor: Colors.white, // Checkmark color
                    ),
                    Expanded(
                      child: Text(
                        milestoneTitles[index],
                        style: h4.copyWith(color: AppColors.textColor,fontSize: 20),
                      ),
                    ),
                  ],
                );
              }),
            )),
            SizedBox(height: 40,),
            // Button showing selected count
            Obx(() {
              final selectedCount = checkboxStates.where((e) => e).length;
              return selectedCount > 0
                  ? CustomButton(
                label: 'Selected ($selectedCount) Milestone${selectedCount > 1 ? 's' : ''}',
                onPressed: () {
                  Get.offAll(DashboardView());
                },
              )
                  : const SizedBox.shrink(); // Hide button if no checkboxes selected
            }),
          ],
        ),
      ),
    );
  }
}