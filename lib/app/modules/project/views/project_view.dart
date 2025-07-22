import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import 'package:loan_site/app/modules/project/controllers/project_controller.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../home/views/upload_photo_view.dart';
import '../../home/views/view_instruction_view.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text('Progress'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Header
                  Text(
                    'Sunset Grove Residences',
                    style: h3.copyWith(
                      fontSize: 24,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Residential Development Project',
                    style: h4.copyWith(
                      fontSize: 16,
                      color: AppColors.blurtext5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Progress Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.cardGradient1, AppColors.cardGradient2],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Progress',
                                  style: h1.copyWith(
                                    color: AppColors.textWhite1,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  '(4 of 10 Milestone completed)',
                                  style: h3.copyWith(
                                    color: AppColors.textWhite1,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '85% Complete',
                                style: h3.copyWith(
                                  color: AppColors.textColor5,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.4,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.progressClr,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Started: Jan 15, 2024',
                              style: h4.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Estimated: Jun 15, 2024',
                              style: h4.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildStatCard('12', 'Days Remaining', AppColors.clrOrange)),
                      Expanded(child: _buildStatCard('12', 'Budget Used', AppColors.clrGreen)),
                      Expanded(child: _buildStatCard('4/10', 'Task Done', AppColors.clrBrown)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Project Information',
                      style: h3.copyWith(
                        color: AppColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _projectInformation('Project Name :', 'Grove Development LLC'),
                  _projectInformation('Project Type :', 'Residential Development'),
                  _projectInformation('Location :', 'Sunset Grove, CA'),
                  _projectInformation('Project Manager :', 'Sarah Johnson'),
                  _projectInformation('Budget Used :', '\$1.6M (68%)'),
                  // Current phase
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Current Phase',
                      style: h3.copyWith(
                        color: AppColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.cardGradient3, AppColors.cardGradient4],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plumbing Installation',
                                  style: h1.copyWith(
                                    color: AppColors.textWhite1,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  '(4 of 10 Milestone completed)',
                                  style: h3.copyWith(
                                    color: AppColors.textWhite1,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '85% Complete',
                                style: h3.copyWith(
                                  color: AppColors.textColor5,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.4,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.textColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Installing plumbing systems in buildings A and B. Expected completion in 5 days.',
                          style: h4.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => Get.to(ViewInstructionView()),
                      child: SvgPicture.asset('assets/images/project/view_instruction.svg',width: MediaQuery.of(context).size.width,),
                    ),
                  ),
                  // Add padding to prevent content from being hidden under the fixed button
                  const SizedBox(height: 60), // Adjust based on button height
                ],
              ),
            ),
            // Fixed button at the bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: CustomButton(
                svgPath: 'assets/images/project/switch_icon.svg',
                label: 'Switch to this project',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectInformation(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title, style: h4.copyWith(color: AppColors.gray7, fontSize: 16)),
          const SizedBox(width: 6),
          Text(details, style: h3.copyWith(color: AppColors.textColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: h1.copyWith(
                  fontSize: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: h4.copyWith(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}