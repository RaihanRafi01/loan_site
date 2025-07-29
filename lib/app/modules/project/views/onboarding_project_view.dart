import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/dashboard/views/dashboard_view.dart';
import 'package:loan_site/app/modules/project/views/create_project_view.dart';
import 'package:loan_site/app/modules/project/views/project_list_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';

class OnboardingProjectView extends GetView {
  final bool newUser;
  const OnboardingProjectView({super.key, this.newUser = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: newUser
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Create Project',
                    style: h2.copyWith(
                      fontSize: 24,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                CustomButton(
                  label: 'Create a project',
                  svgPath: 'assets/images/project/plus_icon.svg',
                  onPressed: () => Get.to(CreateProjectView()),
                ),
              ],
            )
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Projects',
                    style: h2.copyWith(
                      fontSize: 24,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CustomButton(
                    bgClr: [AppColors.btnClr1, AppColors.btnClr1],
                    borderColor: AppColors.btnBdr1,
                    label: 'All Projects',
                    svgPath: 'assets/images/project/all_project_icon.svg',
                    txtClr: AppColors.textColor,
                    onPressed: () => Get.to(ProjectListView()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CustomButton(
                    bgClr: [AppColors.btnClr2, AppColors.btnClr2],
                    borderColor: AppColors.btnBdr2,
                    label: 'Active Projects',
                    svgPath: 'assets/images/project/active_project_icon.svg',
                    txtClr: AppColors.textColor,
                    onPressed: () => Get.to(ProjectListView()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CustomButton(
                    bgClr: [AppColors.btnClr3, AppColors.btnClr3],
                    borderColor: AppColors.btnBdr3,
                    label: 'Completed Projects',
                    svgPath: 'assets/images/project/tic_image.svg',
                    txtClr: AppColors.textColor,
                    onPressed: () => Get.to(ProjectListView()),
                  ),
                ),
                SizedBox(height: 50),
                CustomButton(
                  label: 'Go Home',
                  onPressed: () => Get.to(DashboardView()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}