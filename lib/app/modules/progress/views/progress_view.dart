import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import 'package:loan_site/app/modules/home/views/upload_photo_view.dart';
import 'package:loan_site/app/modules/home/views/view_instruction_view.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import '../../contractor/views/contractor_view.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/progress_controller.dart';

class ProgressView extends GetView {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'Progress',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final HomeController homeController = Get.find<HomeController>();
            final project = homeController.currentProject.value;
            if (project == null) {
              return const Center(
                child: Text(
                  'No project selected',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.blurtext5,
                  ),
                ),
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
                                horizontal: 12, vertical: 6),
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
                // Stat Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        project.progress.daysRemaining?.toString() ?? 'N/A',
                        'Days Remaining',
                        AppColors.clrOrange,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        project.progress.budget_used?.toString() ?? 'N/A',
                        'Budget Used',
                        AppColors.clrGreen,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        '${project.progress.completedPhases}/${project.progress.totalPhases}',
                        'Task Done',
                        AppColors.clrBrown,
                      ),
                    ),
                  ],
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
                // Milestones (Moved out of nested Obx)
                Builder(builder: (context) {
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
                            child: HomeView().buildMilestoneCard(
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
                              child: HomeView().buildMilestoneCard(
                                displayMilestones[i + 1].name,
                                displayMilestones[i + 1].status == 'completed'
                                    ? 'assets/images/home/tic_icon.svg'
                                    : 'assets/images/home/waiting_icon.svg',
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

                  return Column(children: milestoneRows);
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
                        'Complete ${project.milestones.firstWhereOrNull((m) => m.status == 'on_going')?.name ?? 'General'} and upload progress photos',
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
                        onTap: () => Get.to(ContractorView()),
                        child: SvgPicture.asset(
                          'assets/images/home/view_instruction.svg',
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    // Format value as currency if the label is 'Budget Used'
    String displayValue = value;
    if (label == 'Budget Used' && value != 'N/A') {
      try {
        final number = double.parse(value.replaceAll(',', '')); // Remove commas if already present
        displayValue = '\$${NumberFormat('#,##0').format(number)}'; // Format with $ and commas
      } catch (e) {
        displayValue = value; // Fallback to original value if parsing fails
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayValue,
                textAlign: TextAlign.center,
                style: h1.copyWith(
                  fontSize: 18,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: h4.copyWith(
                  fontSize: 12,
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