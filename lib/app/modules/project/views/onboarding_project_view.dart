import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import 'package:loan_site/app/modules/project/views/create_project_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class   extends GetView {
  const OnboardingProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
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
                    onPressed: () => Get.to(CreateProjectView()),
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
                    onPressed: () => Get.to(CreateProjectView()),
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
                    onPressed: () => Get.to(CreateProjectView()),
                  ),
                ),
                SizedBox(height: 50),
                CustomButton(
                  label: 'Go Home',
                  onPressed: () => Get.to(HomeView()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
