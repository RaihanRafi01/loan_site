import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class FilePickerService {
  // Pick a file and return a map with data URI and message type
  Future<Map<String, String>?> pickFile() async {
    developer.log('File picker button tapped', name: 'FilePickerService');

    // Request photos/storage permission
    PermissionStatus permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          final file = result.files.single;
          String? base64File;
          String fileName = file.name;

          // Check file size (10MB limit)
          if (file.size > 10 * 1024 * 1024) {
            developer.log(
              'File too large: $fileName, size: ${file.size} bytes',
              name: 'FilePickerService',
            );
            Get.snackbar('Error', 'File size exceeds 10MB limit');
            return null;
          }

          // Read file content
          if (file.bytes != null) {
            base64File = base64Encode(file.bytes!);
          } else if (file.path != null) {
            try {
              final fileContent = await File(file.path!).readAsBytes();
              base64File = base64Encode(fileContent);
            } catch (e) {
              developer.log(
                'Failed to read file from path: $fileName, error: $e',
                name: 'FilePickerService',
                error: e,
              );
              Get.snackbar('Error', 'Failed to read file: $e');
              return null;
            }
          } else {
            Get.snackbar('Error', 'Unable to read file content');
            return null;
          }

          // Determine MIME type and message type
          final ext = (file.extension ?? '').toLowerCase();
          String mime;
          String messageType;
          if (ext == 'jpg' || ext == 'jpeg') {
            mime = 'image/jpeg';
            messageType = 'image';
          } else if (ext == 'png') {
            mime = 'image/png';
            messageType = 'image';
          } else if (ext == 'pdf') {
            mime = 'application/pdf';
            messageType = 'file';
          } else {
            mime = 'application/octet-stream';
            messageType = 'file';
          }

          final dataUri = 'data:$mime;base64,$base64File';
          developer.log('File picked: $fileName, type: $messageType', name: 'FilePickerService');

          return {
            'dataUri': dataUri,
            'messageType': messageType,
          };
        } else {
          Get.snackbar('Info', 'No file selected');
          return null;
        }
      } catch (e) {
        developer.log('File picker error: $e', name: 'FilePickerService', error: e);
        Get.snackbar('Error', 'Failed to pick file: $e');
        return null;
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      Get.snackbar('Error', 'Please enable storage permission in settings');
      await openAppSettings();
      return null;
    } else {
      Get.snackbar('Error', 'Storage permission denied');
      return null;
    }
  }
}