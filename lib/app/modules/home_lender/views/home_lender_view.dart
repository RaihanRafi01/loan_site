import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../notification/views/notification_view.dart';

class HomeLenderView extends GetView {
  const HomeLenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SingleChildScrollView(
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
                    onTap: ()=> Get.to(NotificationView()) ,
                    child: SvgPicture.asset('assets/images/home/notification_icon.svg')),
              ],
            ),
            SizedBox(height: 30),
            // Overview Section
            Text(
              'Overview',
              style: h3.copyWith(
                fontSize: 20,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Grid
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
                  value: '20',
                  label: 'Total Projects',
                  color: AppColors.lenderSky,
                ),
                _buildStatCard(
                  svgPath: 'assets/images/home/dolar_icon.svg',
                  value: '10.M',
                  label: 'Total Loan Value',
                  color: AppColors.lenderYellow,
                ),
                _buildStatCard(
                  svgPath: 'assets/images/home/tic_big_icon.svg',
                  value: '14',
                  label: 'Complete Projects',
                  color: AppColors.lenderGreen,
                ),
                _buildStatCard(
                  svgPath: 'assets/images/home/flag_big_icon.svg',
                  value: '3',
                  label: 'Pending',
                  color: AppColors.lenderRed,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Projects Section
            Text(
              'Projects',
              style: h3.copyWith(
                fontSize: 20,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Projects List
            _buildProjectCard(
              projectName: 'Oakridge Villas',
              companyName: 'Smith Development LLC',
              progress: 75,
              status: 'On going',
              statusColor: AppColors.textYellow,
            ),
            const SizedBox(height: 12),
            _buildProjectCard(
              projectName: 'Downtown Plaza',
              companyName: 'Metro Construction',
              progress: 45,
              status: 'Delayed',
              statusColor: AppColors.lenderRed,
            ),
            const SizedBox(height: 12),
            _buildProjectCard(
              projectName: 'Riverside Apartments',
              companyName: 'Riverside Holdings',
              progress: 95,
              status: 'On Going',
              statusColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildProjectCard(
              projectName: 'Tech Campus Phase 2',
              companyName: 'Innovation Partners',
              progress: 100,
              status: 'Completed',
              statusColor: AppColors.clrGreen,
            ),
          ],
        ),
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
              SizedBox(width: 8),
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
                  SizedBox(height: 6),
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