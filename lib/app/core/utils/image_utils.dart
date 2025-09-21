import 'package:flutter/material.dart';

import '../../../common/appColors.dart';
import '../constants/api.dart';

class ImageUtils {
  static String getImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'https://via.placeholder.com/100';
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return '${Api.baseUrlPicture}$url';
  }

  static Widget buildAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.gray10,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 36,
          height: 36,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              'https://via.placeholder.com/100',
              fit: BoxFit.cover,
              width: 36,
              height: 36,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                color: AppColors.textColor,
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}