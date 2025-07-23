import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart';

class CreatePostView extends GetView<CommunityController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBc,
        elevation: 0,
        title: Text(
          'Create Post',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Hello Angelo!',
                    style: h2.copyWith(
                      fontSize: 24,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomTextField(
                  labelText: 'What’s on your mind',
                  controller: controller.statusController,
                  maxLine: 6,
                  bgClr: AppColors.textInputField2,
                  radius: 6,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/community/photo_icon.svg'),
                  const SizedBox(width: 10),
                  Text(
                    'Photos/Videos',
                    style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: CustomButton(label: 'Post', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // Camera button
              SvgPicture.asset('assets/images/home/cam_icon.svg'),
              const SizedBox(width: 8),
              // Image/Gallery button
              SvgPicture.asset('assets/images/home/image_icon.svg'),
              const SizedBox(width: 12),
              // Text input field with mic icon
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.chatInput,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Type here...',
                            border: InputBorder.none,
                            hintStyle: h4.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SvgPicture.asset('assets/images/home/mic_icon.svg'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send button
              SvgPicture.asset('assets/images/home/send_icon.svg'),
            ],
          ),
        ),
      ),
    );
  }
}