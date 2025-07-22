import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../home/views/upload_photo_view.dart';
import '../../home/views/view_instruction_view.dart';
import '../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

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
        child: SingleChildScrollView(
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
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildStatCard('12', 'Days Remaining', AppColors.clrOrange)),
                  Expanded(child: _buildStatCard('12', 'Budget Used', AppColors.clrGreen)),
                  Expanded(child: _buildStatCard('4/10', 'Task Done', AppColors.clrBrown)),
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
              Row(
                children: [
                  Expanded(
                    child: HomeView().buildMilestoneCard(
                      'Planning & Permit',
                      'assets/images/home/tic_icon.svg',
                      AppColors.greenCard,
                      AppColors.textGreen,
                      true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeView().buildMilestoneCard(
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
                    child: HomeView().buildMilestoneCard(
                      'Electrical Work',
                      'assets/images/home/tic_icon.svg',
                      AppColors.greenCard,
                      AppColors.textGreen,
                      true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeView().buildMilestoneCard(
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
                    child: GestureDetector(
                        onTap: ()=> Get.to(UploadPhotoView()),
                        child: SvgPicture.asset('assets/images/home/upload_photo.svg',width: MediaQuery.of(context).size.width,height:  100,)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                        onTap: ()=> Get.to(ViewInstructionView()),
                        child: SvgPicture.asset('assets/images/home/view_instruction.svg',width: MediaQuery.of(context).size.width,height: 100,)),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          padding: EdgeInsets.all(8),
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
              SizedBox(height: 4),
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