import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/dashboard/controllers/dashboard_lender_controller.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../notification/views/notification_view.dart';

class HomeLenderView extends GetView<DashboardLenderController> {
  const HomeLenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.fetchOverviewData(),
        builder: (context, overviewSnapshot) {
          if (overviewSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (overviewSnapshot.hasError) {
            return Center(child: Text('Error: ${overviewSnapshot.error}'));
          }
          final overviewData = overviewSnapshot.data ?? {};

          return FutureBuilder<Map<String, dynamic>>(
            future: controller.fetchProjectsData(),
            builder: (context, projectsSnapshot) {
              if (projectsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (projectsSnapshot.hasError) {
                return Center(child: Text('Error: ${projectsSnapshot.error}'));
              }
              final projectList = projectsSnapshot.data?['results'] ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => controller.profileImageUrl.value.isNotEmpty
                                ? Image.network(
                              controller.profileImageUrl.value,
                              scale: 4,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    'assets/images/home/user_image.png',
                                    scale: 4,
                                  ),
                            )
                                : Image.asset(
                              'assets/images/home/user_image.png',
                              scale: 4,
                            )),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                  controller.name.value.isNotEmpty
                                      ? controller.name.value
                                      : 'User',
                                  style: h2.copyWith(
                                    color: AppColors.textColor,
                                    fontSize: 24,
                                  ),
                                )),
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
                          onTap: () => Get.to(const NotificationView()),
                          child: SvgPicture.asset(
                              'assets/images/home/notification_icon.svg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Overview',
                      style: h3.copyWith(
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _buildStatCard(
                          svgPath: 'assets/images/home/project_icon.svg',
                          value: overviewData['total_projects_count']?.toString() ?? '0',
                          label: 'Total Projects',
                          color: AppColors.lenderSky,
                        ),
                        _buildStatCard(
                          svgPath: 'assets/images/home/dolar_icon.svg',
                          value: controller.formatLoanValue(overviewData['total_loan_value_count']),
                          label: 'Total Loan Value',
                          color: AppColors.lenderYellow,
                        ),
                        _buildStatCard(
                          svgPath: 'assets/images/home/tic_big_icon.svg',
                          value: overviewData['completed_projects_count']?.toString() ?? '0',
                          label: 'Complete Projects',
                          color: AppColors.lenderGreen,
                        ),
                        _buildStatCard(
                          svgPath: 'assets/images/home/flag_big_icon.svg',
                          value: overviewData['pending_projects_count']?.toString() ?? '0',
                          label: 'Pending',
                          color: AppColors.lenderRed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Projects',
                      style: h3.copyWith(
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...projectList.map<Widget>((project) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildProjectCard(
                        projectName: project['name'] ?? 'Unknown',
                        companyName: project['location'] ?? 'Unknown',
                        progress: project['progress_percentage'] ?? 0,
                        status: project['project_status'] ?? 'Unknown',
                        statusColor: controller.getStatusColor(project['project_status']),
                      ),
                    )).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String svgPath,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(svgPath),
              const SizedBox(width: 8),
              Text(
                value,
                style: h1.copyWith(
                  fontSize: 32,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: h4.copyWith(
              fontSize: label == 'Pending' ? 20 : 16,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String projectName,
    required String companyName,
    required int progress,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: h3.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      companyName,
                      style: h4.copyWith(
                        fontSize: 14,
                        color: AppColors.gray12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$progress% Progress',
                    style: h3.copyWith(
                      fontSize: 14,
                      color: AppColors.lenderSky,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(
                      status,
                      style: h3.copyWith(
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}