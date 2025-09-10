import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class UploadPhotoController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;
  RxInt currentImageIndex = 0.obs;
  RxBool showImageOverlay = false.obs;
  PageController pageController = PageController();

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((xfile) => File(xfile.path)));
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    if (currentImageIndex.value >= selectedImages.length &&
        selectedImages.isNotEmpty) {
      currentImageIndex.value = selectedImages.length - 1;
      pageController.jumpToPage(currentImageIndex.value);
    } else if (selectedImages.isEmpty) {
      showImageOverlay.value = false;
    }
  }

  void showImageViewer(int index) {
    currentImageIndex.value = index;
    pageController = PageController(initialPage: index);
    showImageOverlay.value = true;
  }

  void nextImage() {
    if (currentImageIndex.value < selectedImages.length - 1) {
      currentImageIndex.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousImage() {
    if (currentImageIndex.value > 0) {
      currentImageIndex.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void closeImageViewer() {
    showImageOverlay.value = false;
  }

  void showUploadOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Photos',
              style: h3.copyWith(fontSize: 18, color: AppColors.textColor),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImageFromCamera();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.chatCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray5),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: AppColors.clrBlue1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Camera',
                            style: h4.copyWith(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImages();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.chatCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray5),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 30,
                            color: AppColors.clrBlue1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: h4.copyWith(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}