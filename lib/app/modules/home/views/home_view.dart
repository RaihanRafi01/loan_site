import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(children: [
                  Image.asset('assets/images/home/user_image.png',scale: 4,),
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
                ],),
                SvgPicture.asset('assets/images/home/notification_icon.svg')
              ],),
              const SizedBox(height: 30),
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
                padding: const EdgeInsets.all(20),
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
                      height: 16, // Increased for visibility
                      width: double.infinity, // Extend to full width
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.4, // Progress bar at 85% width
                        alignment: Alignment.centerLeft, // Start from the left
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
        
              Row(
                children: [
                  Expanded(
                    child: _buildMilestoneCard(
                      'Planning & Permit',
                      'assets/images/home/tic_icon.svg',
                      AppColors.greenCard,
                      AppColors.textGreen,
                      true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMilestoneCard(
                      'Demolition',
                      'assets/images/home/tic_icon.svg',
                      AppColors.greenCard,
                      AppColors.textGreen,
                      true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
        
              Row(
                children: [
                  Expanded(
                    child: _buildMilestoneCard(
                      'Electrical Work',
                      'assets/images/home/tic_icon.svg',
                      AppColors.greenCard,
                      AppColors.textGreen,
                      true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMilestoneCard(
                      'Plumbing',
                      'assets/images/home/waiting_icon.svg',
                      AppColors.yellowCard,
                      AppColors.textYellow,
                      false,
                      subtitle: 'On going',
                    ),
                  ),
                ],
              ),
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
                      'Complete plumbing installation and upload progress photos',
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
                    child: SvgPicture.asset('assets/images/home/upload_photo.svg')
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SvgPicture.asset('assets/images/home/view_instruction.svg')
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
        
              _buildUpdateCard(
                'Milestone Reminder',
                'Plumbing work deadline is approaching in 3 days',
                'assets/images/home/info_icon.svg',
                AppColors.yellowCard,
                AppColors.textYellow,
              ),
              const SizedBox(height: 12),
        
              _buildUpdateCard(
                'Milestone Reminder',
                'Electrical work milestone completed successfully',
                'assets/images/home/tic_icon.svg',
                AppColors.greenCard,
                AppColors.textGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard( String title, String svgPath, Color color, Color txtColor, bool isCompleted, {String? subtitle}) {
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
                  style:  h4.copyWith(
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

  Widget _buildUpdateCard(String title, String description, String svgPath, Color color, Color txtColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: txtColor.withOpacity(0.1), // Border color (you can change to any color, e.g., Colors.black)
          width: 1, // Border width (adjust as needed)
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