import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/views/create_project_view.dart';
import 'package:loan_site/app/modules/project/views/project_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/project_controller.dart';

class ProjectListView extends GetView<ProjectController> {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBc,
        elevation: 0,
        title: Text(
          'My Project',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Projects List
            Expanded(
              child: ListView(
                children: [
                  _buildProjectCard(
                    title: 'Sunset Grove Residences',
                    onTap: () {
                     Get.to(ProjectView());
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProjectCard(
                    title: 'Sunset Grove Residences',
                    onTap: () {
                      Get.to(ProjectView());
                    },
                  ),
                ],
              ),
            ),

            // Create Project Button
            const SizedBox(height: 16),
            CustomButton(label: 'Create Project', svgPath: 'assets/images/project/plus_icon.svg', onPressed: (){
              Get.to(CreateProjectView());
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSky, // Light blue background
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        title: Text(
          title,
          style: h3.copyWith(
            color: AppColors.appColor2, // Blue text color
            fontSize: 20,
          ),
        ),
        trailing: SvgPicture.asset('assets/images/project/arrow_right.svg'),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}