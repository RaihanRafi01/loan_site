import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';  // New import
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart';

class CreatePostView extends GetView<CommunityController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());  // Note: This might be redundant if using GetView; consider removing if controller is lazy-loaded elsewhere.
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
              GestureDetector(
                onTap: () {
                  controller.pickMedia();  // Picks multiple photos/videos from device and updates state.
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/community/photo_icon.svg'),
                    const SizedBox(width: 10),
                    Text(
                      'Photos/Videos',
                      style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
                    ),
                  ],
                ),
              ),
              Obx(() {  // Reactively show previews if media is picked.
                if (controller.pickedMedia.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: controller.pickedMedia.length,
                    itemBuilder: (context, index) {
                      final file = controller.pickedMedia[index];
                      final isImage = file.path.toLowerCase().endsWith('.jpg') ||
                          file.path.toLowerCase().endsWith('.jpeg') ||
                          file.path.toLowerCase().endsWith('.png') ||
                          file.path.toLowerCase().endsWith('.gif');
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isImage
                            ? Image.file(
                          file,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        )
                            : const Icon(Icons.videocam, size: 50),  // Placeholder for videos.
                      );
                    },
                  ),
                );
              }),
              Obx(() => Padding(  // Make the button reactive to isLoading.
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: CustomButton(
                  isLoading: controller.isLoading.value,
                  label: 'Post',
                  onPressed: () {
                    controller.postContent();
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}