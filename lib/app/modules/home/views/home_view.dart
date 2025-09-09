import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/chat_home_view.dart';
import 'package:loan_site/app/modules/home/views/upload_photo_view.dart';
import 'package:loan_site/app/modules/home/views/view_instruction_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_view.dart';
import 'package:loan_site/app/modules/project/views/project_list_view.dart';
import 'package:loan_site/app/modules/project/views/startMilestone_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';
import '../../project/controllers/project_controller.dart'; // For ProjectDetail

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return Scaffold(
      backgroundColor: AppColors.appBc,
      floatingActionButton: Obx(
        () => controller.currentProject.value != null
            ? FloatingActionButton(
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
              )
            : const SizedBox.shrink(),
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
                      // Dynamic profile image
                      dashboardController.profileImageUrl.value.isNotEmpty
                          ? CircleAvatar(
                              radius: 40, // Adjust size as needed
                              backgroundImage: NetworkImage(
                                dashboardController.profileImageUrl.value,
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                // Handle image loading error (optional)
                                print(
                                  'Error loading profile image: $exception',
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/home/user_image.png',
                              scale: 4,
                            ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dashboardController.name.value.isNotEmpty
                                ? dashboardController.name.value
                                : 'User', // Fallback if name is empty
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
                    onTap: () => Get.to(() => NotificationView()),
                    child: SvgPicture.asset(
                      'assets/images/home/notification_icon.svg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Project Section
              Obx(() {
                final project = controller.currentProject.value;
                if (project == null) {
                  return CustomButton(
                    label: 'Select project to continue',
                    onPressed: () {
                      Get.to(ProjectListView());
                    },
                    radius: 6,
                    svgPath2: 'assets/images/home/double_arrow_icon.svg',
                    fontSize: 16,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Header
                    Text(
                      project.name,
                      style: h3.copyWith(
                        fontSize: 24,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.type,
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
                          colors: [
                            AppColors.cardGradient1,
                            AppColors.cardGradient2,
                          ],
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
                                    '(${project.progress.completedPhases} of ${project.progress.totalPhases} Milestones completed)',
                                    style: h3.copyWith(
                                      color: AppColors.textWhite1,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${project.progress.percent100}% Complete',
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
                              widthFactor: project.progress.percent0to1,
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
                                'Started: ${project.progress.fmtDate(project.progress.startDate)}',
                                style: h4.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Estimated: ${project.progress.fmtDate(project.progress.endDate)}',
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
                      if (project == null) {
                        return Text(
                          'No project selected',
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.blurtext5,
                          ),
                        );
                      }

                      // Get completed and ongoing milestones
                      final completedMilestones = project.milestones
                          .asMap()
                          .entries
                          .where((entry) => entry.value.status == 'completed')
                          .take(4) // Limit to 4 completed milestones
                          .map((entry) => entry.value)
                          .toList();

                      final ongoingMilestone = project.milestones
                          .firstWhereOrNull((m) => m.status == 'on_going');

                      // Check if there are any milestones
                      final hasMilestones = project.milestones.isNotEmpty;

                      if (!hasMilestones) {
                        return Text(
                          'No milestones available',
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.blurtext5,
                          ),
                        );
                      }

                      // Combine completed and ongoing milestones for display
                      final displayMilestones = [
                        ...completedMilestones,
                        if (ongoingMilestone != null) ongoingMilestone,
                      ];

                      // Build milestone rows dynamically
                      List<Widget> milestoneRows = [];
                      for (int i = 0; i < displayMilestones.length; i += 2) {
                        milestoneRows.add(
                          Row(
                            children: [
                              Expanded(
                                child: buildMilestoneCard(
                                  displayMilestones[i].name,
                                  displayMilestones[i].status == 'completed'
                                      ? 'assets/images/home/tic_icon.svg'
                                      : 'assets/images/home/waiting_icon.svg',
                                  displayMilestones[i].status == 'completed'
                                      ? AppColors.greenCard
                                      : AppColors.yellowCard,
                                  displayMilestones[i].status == 'completed'
                                      ? AppColors.textGreen
                                      : AppColors.textYellow,
                                  displayMilestones[i].status == 'completed',
                                ),
                              ),
                              if (i + 1 < displayMilestones.length) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: buildMilestoneCard(
                                    displayMilestones[i + 1].name,
                                    displayMilestones[i + 1].status == 'completed'
                                        ? 'assets/images/home/tic_icon.svg'
                                        : 'assets/images/home/ongoing_icon.svg',
                                    displayMilestones[i + 1].status == 'completed'
                                        ? AppColors.greenCard
                                        : AppColors.yellowCard,
                                    displayMilestones[i + 1].status == 'completed'
                                        ? AppColors.textGreen
                                        : AppColors.textYellow,
                                    displayMilestones[i + 1].status == 'completed',
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(width: 12),
                                const Expanded(child: SizedBox.shrink()),
                              ],
                            ],
                          ),
                        );
                        milestoneRows.add(const SizedBox(height: 12));
                      }

                      return Column(
                        children: [
                          // Milestone cards
                          ...milestoneRows,
                          // Button for completing or starting the next phase
                          Row(
                            children: [
                              const Expanded(child: SizedBox.shrink()),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  label: ongoingMilestone != null ? 'Complete Phase' : 'Start Next Phase',
                                  onPressed: () {
                                    if (ongoingMilestone != null) {
                                      // Assuming a method exists in the controller to handle completion
                                      // controller.completeCurrentMilestone();
                                      Get.to(StartMilestoneView());
                                    } else {
                                      Get.to(StartMilestoneView());
                                    }
                                  },
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
                    Container(
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
                            'Complete ${project.milestones.firstWhereOrNull((m) => m.status != 'completed')?.name ?? 'General'} and upload progress photos',
                            style: h4.copyWith(
                              color: AppColors.textColor2,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      final currentMilestone =
                          project.milestones
                              .firstWhereOrNull((m) => m.status != 'completed')
                              ?.name ??
                          'General';
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
                          if (project.milestones.any(
                            (m) => m.status == 'completed',
                          ))
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
                );
              }),
            ],
          ),
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
                  style: h4.copyWith(fontSize: 16, color: txtColor),
                ),
              ),
              if (subtitle != null) ...[
                Text(
                  subtitle,
                  style: h4.copyWith(fontSize: 12, color: txtColor),
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
        border: Border.all(color: txtColor.withOpacity(0.1), width: 1),
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
                Text(title, style: h4.copyWith(fontSize: 16, color: txtColor)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: h4.copyWith(fontSize: 14, color: AppColors.gray1),
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
    final Offset defaultOffset = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);
    return Offset(defaultOffset.dx, defaultOffset.dy - 40);
  }
}
