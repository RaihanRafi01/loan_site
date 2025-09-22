import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../controllers/community_controller.dart';

class EditPostView extends GetView<CommunityController> {
  final Post post;

  EditPostView({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: post.title);
    final TextEditingController contentController = TextEditingController(text: post.content);
    final RxList<int> removedImageIds = RxList<int>([]);

    controller.pickedMedia.clear();

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Post',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: h3.copyWith(fontSize: 18, color: AppColors.textColor),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter post title',
                  hintStyle: h4.copyWith(color: AppColors.blurtext2),
                  filled: true,
                  fillColor: AppColors.textInputField2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Content',
                style: h3.copyWith(fontSize: 18, color: AppColors.textColor),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What’s on your mind?',
                  hintStyle: h4.copyWith(color: AppColors.blurtext2),
                  filled: true,
                  fillColor: AppColors.textInputField2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Pick Images',
                onPressed: () => controller.pickMedia(),
                bgClr: [AppColors.cardSky, AppColors.cardSky],
                txtClr: AppColors.appColor2,
                svgPath: 'assets/images/community/plus_icon_blue.svg',
              ),
              const SizedBox(height: 16),
              Obx(() {
                final images = [
                  ...post.images
                      .asMap()
                      .entries
                      .where((entry) => entry.value.image.isNotEmpty)
                      .map((entry) => {
                    'image': entry.value.image,
                    'isNetwork': true,
                    'index': entry.key,
                    'id': entry.value.id,
                  }),
                  ...controller.pickedMedia.asMap().entries.map((entry) => {
                    'image': entry.value.path,
                    'isNetwork': false,
                    'index': entry.key + post.images.length,
                    'id': null,
                  }),
                ];
                debugPrint('Images data in EditPostView: ${images.map((img) => {'image': img['image'], 'isNetwork': img['isNetwork'], 'id': img['id']}).toList()}');
                if (images.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: images.map((imageData) {
                    final index = imageData['index'] as int;
                    final imagePath = imageData['image'] as String;
                    final isNetwork = imageData['isNetwork'] as bool;
                    final imageId = imageData['id'] as int?;

                    debugPrint('Displaying image: $imagePath, isNetwork: $isNetwork, id: $imageId');

                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image(
                            image: isNetwork
                                ? NetworkImage(imagePath)
                                : FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Image load error: $error');
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (isNetwork && imageId != null) {
                                removedImageIds.add(imageId);
                                post.images.removeAt(index < post.images.length ? index : 0);
                              } else {
                                controller.pickedMedia.removeAt(index - post.images.length);
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
              const Spacer(),
              Obx(() => CustomButton(
                label: controller.isLoading.value ? 'Updating...' : 'Update Post',
                onPressed: controller.isLoading.value
                    ? (){}
                    : () => controller.updatePost(
                  post.id,
                  titleController.text,
                  contentController.text,
                  post.images,
                  controller.pickedMedia,
                  removedImageIds,
                ),
                bgClr: [AppColors.cardSky, AppColors.cardSky],
                txtClr: AppColors.appColor2,
                fontSize: 16,
                width: double.infinity,
                height: 48,
              )),
            ],
          ),
        ),
      ),
    );
  }
}