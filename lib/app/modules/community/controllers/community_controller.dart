import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;  // Added for MultipartRequest.
import 'package:image_picker/image_picker.dart';

import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';

class CommunityController extends GetxController {
  final statusController = TextEditingController();
  final pickedMedia = RxList<File>([]);
  final isLoading = false.obs;

  void _showWarning(String message, {String title = 'Warning'}) {
    kSnackBar(
      title: title,
      message: message,
      bgColor: AppColors.snackBarWarning,
    );
  }

  Future<void> pickMedia() async {
    final picker = ImagePicker();
    final pickedFiles = await picker
        .pickMultipleMedia(); // Allows selecting multiple images/videos.
    if (pickedFiles.isNotEmpty) {
      pickedMedia.addAll(pickedFiles.map((f) => File(f.path)));
    }
  }

  Future<void> postContent() async {
    if (statusController.text.isEmpty && pickedMedia.isEmpty) {
      _showWarning('Please add some content or media before posting.');
      return;
    }

    isLoading.value = true;
    try {

      final body = jsonEncode({"title": "My First Post", "content": statusController.text});
      final response = await BaseClient.postRequest(
        api: Api.createPost,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post created successfully!');
        statusController.clear();
        pickedMedia.clear();
      } else {
        _showWarning('Failed to create post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Post error: $e');
      _showWarning('Failed to create post. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }
}