import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:loan_site/app/modules/contractor/views/contractor_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'chat_home_view.dart';

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
    if (currentImageIndex.value >= selectedImages.length && selectedImages.isNotEmpty) {
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
                          Icon(Icons.camera_alt, size: 30, color: AppColors.clrBlue1),
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
                          Icon(Icons.photo_library, size: 30, color: AppColors.clrBlue1),
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

class UploadPhotoView extends GetView<UploadPhotoController> {
  const UploadPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UploadPhotoController());

    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
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

                // AI Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: ChatHomeView().buildAIMessage(
                    'Hey Angelo, good to see you! You are currently in plumbing. What\'s the progress of your project?',
                    '',
                  ),
                ),

                // Upload Section
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
                            'assets/images/home/upload_icon.svg',
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
                            child: CustomButton(
                              txtClr: AppColors.appColor2,
                              bgClr: [AppColors.chatCard, AppColors.chatCard],
                              label: 'Upload',
                              onPressed: () => controller.showUploadOptions(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Photo Preview Grid
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Obx(() => controller.selectedImages.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 170,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.chatCard,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: controller.selectedImages.length > 6
                              ? 6
                              : controller.selectedImages.length,
                          itemBuilder: (context, index) {
                            if (index == 5 && controller.selectedImages.length > 6) {
                              return GestureDetector(
                                onTap: () => controller.showImageViewer(index),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(controller.selectedImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${controller.selectedImages.length - 5}+',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: () => controller.showImageViewer(index),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(controller.selectedImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.chatCard,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 20),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: CustomButton(
                    label: 'Submit',
                    onPressed: () => Get.to(ChatHomeView()),
                  ),
                )
              ],
            ),

            // Image Overlay Viewer
            // Replace the Image Overlay Viewer section in your code with this:

            Obx(() => controller.showImageOverlay.value && controller.selectedImages.isNotEmpty
                ? Container(
              color: Colors.black.withOpacity(0.9),
              child: Stack(
                children: [
                  // Main image viewer
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (index) => controller.currentImageIndex.value = index,
                        itemCount: controller.selectedImages.length,
                        itemBuilder: (context, index) {
                          return InteractiveViewer(
                            maxScale: 4.0,
                            minScale: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.selectedImages[index],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Top right - Delete and Close buttons
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Row(
                      children: [
                        // Delete button
                        GestureDetector(
                          onTap: () {
                            controller.removeImage(controller.currentImageIndex.value);
                          },
                          child: SvgPicture.asset(
                            'assets/images/home/delete_icon.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Close button
                        GestureDetector(
                          onTap: () => controller.closeImageViewer(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Left navigation arrow (centered vertically)
                  if (controller.selectedImages.length > 1)
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => controller.previousImage(),
                          child: SvgPicture.asset(
                            'assets/images/home/left_icon.svg',
                          ),
                        ),
                      ),
                    ),

                  // Right navigation arrow (centered vertically)
                  if (controller.selectedImages.length > 1)
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => controller.nextImage(),
                          child: SvgPicture.asset(
                            'assets/images/home/right_icon.svg',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}