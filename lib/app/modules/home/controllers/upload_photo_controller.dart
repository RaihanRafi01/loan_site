import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loan_site/app/modules/home/controllers/home_controller.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class UploadPhotoController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;
  RxInt currentImageIndex = 0.obs;
  RxBool showImageOverlay = false.obs;
  PageController pageController = PageController();
  final isLoading = false.obs;
  final botMessages = <String>[].obs; // Store list of bot messages

  // Get the HomeController instance properly using GetX
  final HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with the default message
    botMessages.add('Upload Photo to complete the phase');
  }

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

  void _showWarning(String message, {String title = 'Warning'}) {
    kSnackBar(
      title: title,
      message: message,
      bgColor: AppColors.snackBarWarning,
    );
  }

  Future<void> uploadMilestonePhoto() async {
    // Ensure project data is loaded
    await homeController.loadContextFromPrefs();

    final currentProject = homeController.currentProject.value;

    if (selectedImages.isEmpty) {
      _showWarning('Please select at least one image to upload');
      botMessages.add('Please select at least one image to upload');
      return;
    }

    if (currentProject == null) {
      _showWarning('No project selected. Please select a project first.');
      botMessages.add('No project selected. Please select a project first.');
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    final projectId = currentProject.id;

    // Find the first milestone with 'on_going' status
    final milestone = currentProject.milestones
        .firstWhereOrNull((m) => m.status == 'on_going');

    debugPrint('Project ID: $projectId');
    debugPrint('Milestone: ${milestone?.id} - ${milestone?.name}');

    if (milestone == null) {
      _showWarning('No ongoing milestone found for this project');
      botMessages.add('No ongoing milestone found for this project');
      isLoading.value = false;
      return;
    }

    try {
      var uri = Uri.parse(Api.uploadMilestonePhoto(projectId, milestone.id));
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await BaseClient.authHeaders());

      // Add multiple image files
      for (var file in selectedImages) {
        var multipartFile = await http.MultipartFile.fromPath('images', file.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("API Hit: $uri");
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final responseData = jsonDecode(response.body);
        final aiResult = responseData['ai_result'];
        final bool status = aiResult['status'];
        final String reason = aiResult['reason'] ?? '';
        final String milestoneName = aiResult['milestone'] ?? 'Unknown milestone';

        if (status) {
          // Success case
          _showWarning('Photos uploaded successfully for $milestoneName', title: 'Success');
          botMessages.add('The uploaded photos successfully confirm the completion of "$milestoneName".');
          selectedImages.clear();
          await homeController.refreshContext(); // Refresh project data
        } else {
          // Failure case
          //_showWarning('Photos rejected: $reason', title: 'Upload Failed');
          botMessages.add('$reason Please try with different angle'); // Add the reason as a new bot message
        }
      } else {
        _showWarning('Failed to upload photos: ${response.reasonPhrase}');
        botMessages.add('Failed to upload photos. Please try again.');
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      _showWarning('Failed to upload photos. Please try again.');
      botMessages.add('An error occurred while uploading photos. Please try again.');
    } finally {
      isLoading.value = false;
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