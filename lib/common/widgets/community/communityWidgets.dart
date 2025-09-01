import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/community/views/comments_view.dart';
import '../../../app/modules/community/views/share_post_view.dart';
import '../../appColors.dart';
import '../../customFont.dart';

Widget buildImageGrid(List<String> images) {
  if (images.isEmpty) return const SizedBox.shrink();

  if (images.length == 1) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Image.network(
        images[0],
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) =>
        loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, error, stackTrace) =>
        const Center(child: Icon(Icons.error)),
      ),
    );
  } else if (images.length == 2) {
    return SizedBox(
      height: 200,
      child: Row(
        children: images
            .asMap()
            .entries
            .map(
              (entry) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: entry.key == 0 ? 1 : 0),
              child: Image.network(
                entry.value,
                fit: BoxFit.cover,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  } else if (images.length == 3) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Image.network(
              images[0],
              fit: BoxFit.cover,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.error)),
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 0.5),
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 0.5),
                    child: Image.network(
                      images[2],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    // 4+
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 0.5, bottom: 0.5),
                    child: Image.network(
                      images[0],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 0.5, bottom: 0.5),
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 0.5, top: 0.5),
                    child: Image.network(
                      images[2],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 0.5, top: 0.5),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          images[3],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error)),
                        ),
                        if (images.length > 4)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                '+${images.length - 4}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildActionButton(
    String svgPath,
    String count, {
      VoidCallback? onPressed,
      int? postId,
    }) {
  return GestureDetector(
    onTap: onPressed ??
            () {
          if (svgPath.contains('comment_icon') && postId != null) {
            Get.to(() => CommentsView(postId: postId));
          }
          if (svgPath == 'assets/images/community/share_icon.svg') {
            Get.to(() => const SharePostView(postId: 0)); // TODO pass real postId if needed
          }
        },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: AppColors.cardSky,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgPath),
            if (count.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                count,
                style: h4.copyWith(
                  fontSize: 14,
                  color: AppColors.textColor9,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

String getTimeAgo(DateTime? dateTime) {
  if (dateTime == null) return '';
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inDays > 0) return '${difference.inDays}d';
  if (difference.inHours > 0) return '${difference.inHours}h';
  if (difference.inMinutes > 0) return '${difference.inMinutes}m';
  return 'Just now';
}