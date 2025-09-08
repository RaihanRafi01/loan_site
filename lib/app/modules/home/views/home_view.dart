import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/chat_home_view.dart';
import 'package:loan_site/app/modules/home/views/upload_photo_view.dart';
import 'package:loan_site/app/modules/home/views/view_instruction_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/home_controller.dart';
import '../../project/controllers/project_controller.dart'; // For ProjectDetail

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ChatHomeView());
        },
        backgroundColor: AppColors.progressClr,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: SvgPicture.asset(
          'assets/images/home/chat_floating_button.svg',
          height: 150,
          width: 100,
        ),
      ),
      floatingActionButtonLocation: _CustomFloatingButtonLocation(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/home/user_image.png',
                        scale: 4,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Angelo',
                            style: h2.copyWith(
                              color: AppColors.textColor,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Continue Your Journey',
                            style: h4.copyWith(
                              color: AppColors.blurtext4,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(NotificationView()),
                    child: SvgPicture.asset('assets/images/home/notification_icon.svg'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Project Header
              Obx(() => Text(
                controller.currentProject.value?.name ?? 'No Project Selected',
                style: h3.copyWith(
                  fontSize: 24,
                  color: AppColors.textColor,
                ),
              )),
              const SizedBox(height: 4),
              Obx(() => Text(
                controller.currentProject.value?.type ?? 'Select a project to view details',
                style: h4.copyWith(
                  fontSize: 16,
                  color: AppColors.blurtext5,
                ),
              )),
              const SizedBox(height: 20),
              // Progress Card
              Obx(() {
                final project = controller.currentProject.value;
                if (project == null) {
                  return _buildNoProjectCard();
                }
                final progress = project.progress;
                return Container(
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
                                '(${progress.completedPhases} of ${progress.totalPhases} Milestones completed)',
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
                              '${progress.percent100}% Complete',
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
                          widthFactor: progress.percent0to1,
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
                            'Started: ${progress.fmtDate(progress.startDate)}',
                            style: h4.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Estimated: ${progress.fmtDate(progress.endDate)}',
                            style: h4.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Project Milestones
              const Text(
                'Project Milestones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final project = controller.currentProject.value;
                if (project == null || project.milestones.isEmpty) {
                  return Text(
                    'No milestones available',
                    style: h4.copyWith(
                      fontSize: 16,
                      color: AppColors.blurtext5,
                    ),
                  );
                }
                final milestones = project.milestones;
                // Show up to 3 milestones to fit the existing layout
                final displayMilestones = milestones.take(3).toList();
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: displayMilestones.isNotEmpty
                              ? buildMilestoneCard(
                            displayMilestones[0].name,
                            displayMilestones[0].status == 'completed'
                                ? 'assets/images/home/tic_icon.svg'
                                : 'assets/images/home/waiting_icon.svg',
                            displayMilestones[0].status == 'completed'
                                ? AppColors.greenCard
                                : AppColors.yellowCard,
                            displayMilestones[0].status == 'completed'
                                ? AppColors.textGreen
                                : AppColors.textYellow,
                            displayMilestones[0].status == 'completed',
                            subtitle: displayMilestones[0].status == 'completed'
                                ? null
                                : 'On going',
                          )
                              : Container(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: displayMilestones.length > 1
                              ? buildMilestoneCard(
                            displayMilestones[1].name,
                            displayMilestones[1].status == 'completed'
                                ? 'assets/images/home/tic_icon.svg'
                                : 'assets/images/home/waiting_icon.svg',
                            displayMilestones[1].status == 'completed'
                                ? AppColors.greenCard
                                : AppColors.yellowCard,
                            displayMilestones[1].status == 'completed'
                                ? AppColors.textGreen
                                : AppColors.textYellow,
                            displayMilestones[1].status == 'completed',
                            subtitle: displayMilestones[1].status == 'completed'
                                ? null
                                : 'On going',
                          )
                              : Container(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: displayMilestones.length > 2
                              ? buildMilestoneCard(
                            displayMilestones[2].name,
                            displayMilestones[2].status == 'completed'
                                ? 'assets/images/home/tic_icon.svg'
                                : 'assets/images/home/waiting_icon.svg',
                            displayMilestones[2].status == 'completed'
                                ? AppColors.greenCard
                                : AppColors.yellowCard,
                            displayMilestones[2].status == 'completed'
                                ? AppColors.textGreen
                                : AppColors.textYellow,
                            displayMilestones[2].status == 'completed',
                            subtitle: displayMilestones[2].status == 'completed'
                                ? null
                                : 'On going',
                          )
                              : Container(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            label: 'Start Next Phase',
                            onPressed: () {},
                            radius: 6,
                            svgPath2: 'assets/images/home/double_arrow_icon.svg',
                            height: 45,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              // Next Steps
              Obx(() {
                final project = controller.currentProject.value;
                if (project == null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardSky,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'No next steps available. Select a project.',
                      style: h4.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor2,
                      ),
                    ),
                  );
                }
                final currentMilestone = project.milestones.firstWhereOrNull(
                      (m) => m.status != 'completed',
                )?.name ?? 'General';
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardSky,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Steps',
                        style: h3.copyWith(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Complete $currentMilestone and upload progress photos',
                        style: h4.copyWith(
                          color: AppColors.textColor2,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(UploadPhotoView()),
                      child: SvgPicture.asset(
                        'assets/images/home/upload_photo.svg',
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(ViewInstructionView()),
                      child: SvgPicture.asset(
                        'assets/images/home/view_instruction.svg',
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Recent Updates
              Text(
                'Recent Updates',
                style: h3.copyWith(
                  fontSize: 20,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final project = controller.currentProject.value;
                if (project == null) {
                  return Text(
                    'No recent updates available',
                    style: h4.copyWith(
                      fontSize: 16,
                      color: AppColors.blurtext5,
                    ),
                  );
                }
                final currentMilestone = project.milestones.firstWhereOrNull(
                      (m) => m.status != 'completed',
                )?.name ?? 'General';
                return Column(
                  children: [
                    buildUpdateCard(
                      'Milestone Reminder',
                      '$currentMilestone deadline is approaching in ${project.progress.daysRemaining} days',
                      'assets/images/home/info_icon.svg',
                      AppColors.yellowCard,
                      AppColors.textYellow,
                    ),
                    const SizedBox(height: 12),
                    if (project.milestones.any((m) => m.status == 'completed'))
                      buildUpdateCard(
                        'Milestone Reminder',
                        '${project.milestones.lastWhere((m) => m.status == 'completed').name} completed successfully',
                        'assets/images/home/tic_icon.svg',
                        AppColors.greenCard,
                        AppColors.textGreen,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoProjectCard() {
    return Container(
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
      child: Text(
        'No project selected. Please select a project to view progress.',
        style: h4.copyWith(
          color: AppColors.textWhite1,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildMilestoneCard(
      String title,
      String svgPath,
      Color color,
      Color txtColor,
      bool isCompleted, {
        String? subtitle,
      }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(svgPath),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: h4.copyWith(
                    fontSize: 16,
                    color: txtColor,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                Text(
                  subtitle,
                  style: h4.copyWith(
                    fontSize: 12,
                    color: txtColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUpdateCard(
      String title,
      String description,
      String svgPath,
      Color color,
      Color txtColor,
      ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: txtColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(svgPath),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: h4.copyWith(
                    fontSize: 16,
                    color: txtColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: h4.copyWith(
                    fontSize: 14,
                    color: AppColors.gray1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom FloatingActionButtonLocation to move the button higher
class _CustomFloatingButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset defaultOffset = FloatingActionButtonLocation.endFloat.getOffset(scaffoldGeometry);
    return Offset(defaultOffset.dx, defaultOffset.dy - 40);
  }
}