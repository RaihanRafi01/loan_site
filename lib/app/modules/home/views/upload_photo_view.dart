import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart'; // Import the dotted_border package
import 'package:loan_site/app/modules/contractor/views/contractor_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'chat_home_view.dart';

class UploadPhotoView extends GetView {
  const UploadPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBc,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.maxFinite,
              color: AppColors.chatCard,
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/home/chat_bot.svg'),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: h3.copyWith(
                          color: AppColors.textColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Construction Guide',
                        style: h4.copyWith(
                          color: AppColors.gray2,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ChatHomeView().buildAIMessage(
                'Hey Angelo, good to see you! You are currently in plumbing. What’s the progress of your project?',
                '',
              ),
            ),
            // Upload picture section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  dashPattern: [12, 10],
                  strokeWidth: 2,
                  color: AppColors.gray5,
                  padding: EdgeInsets.all(1),
                  radius: Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/upload_icon.svg', // Replace with your cloud upload SVG path
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upload site Photo',
                        style: h3.copyWith(
                          color: AppColors.clrBlue1,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Take multiple photos of your construction site',
                          style: h4.copyWith(
                            color: AppColors.gray6,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomButton(txtClr: AppColors.appColor2, bgClr : [AppColors.chatCard,AppColors.chatCard],label: 'Upload', onPressed: () {}),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(height: 150,
              color: AppColors.chatCard,),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: CustomButton(label: 'Submit', onPressed: ()=> Get.to(ChatHomeView())),
            )
          ],
        ),
      ),
    );
  }
}
