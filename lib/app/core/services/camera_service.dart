import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class CameraService {
  // Capture an image from the camera and return a base64-encoded data URI
  Future<String?> captureImage() async {
    developer.log('Camera button tapped', name: 'CameraService');

    // Request camera permission
    PermissionStatus permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920, // Limit resolution to reduce file size
          maxHeight: 1080,
          imageQuality: 85, // Compress image
        );

        if (image != null) {
          // Read image bytes
          final bytes = await image.readAsBytes();
          final fileSize = bytes.lengthInBytes;

          // Check file size (10MB limit)
          if (fileSize > 10 * 1024 * 1024) {
            developer.log(
              'Image too large: size: $fileSize bytes',
              name: 'CameraService',
            );
            Get.snackbar('Error', 'Image size exceeds 10MB limit');
            return null;
          }

          // Convert to base64
          final base64Image = base64Encode(bytes);
          final mime = image.mimeType ?? 'image/jpeg'; // Default to JPEG
          final dataUri = 'data:$mime;base64,$base64Image';

          developer.log('Image captured, size: $fileSize bytes', name: 'CameraService');
          return dataUri;
        } else {
          Get.snackbar('Info', 'No image captured');
          return null;
        }
      } catch (e) {
        developer.log('Camera error: $e', name: 'CameraService', error: e);
        Get.snackbar('Error', 'Failed to capture image: $e');
        return null;
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      Get.snackbar('Error', 'Please enable camera permission in settings');
      await openAppSettings();
      return null;
    } else {
      Get.snackbar('Error', 'Camera permission denied');
      return null;
    }
  }
}