import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/community/views/comments_view.dart';
import '../../../app/modules/community/views/share_post_view.dart';
import '../../appColors.dart';
import '../../customFont.dart';

Widget buildImageGrid(List<Map<String, dynamic>> images) {
  if (images.isEmpty) return const SizedBox.shrink();

  // Print the images list to debug
  print('Images data: $images');

  // Extract the URLs safely from the images list
  List<String> imageUrls = images
      .where((image) => image is Map<String, dynamic> && image['image'] is String)
      .map((image) => image['image'] as String)
      .toList();

  if (imageUrls.isEmpty) return const SizedBox.shrink();

  // Handle image grid layouts for 1, 2, 3, or more images
  if (imageUrls.length == 1) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: GestureDetector(
        onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
        child: Image.network(
          imageUrls[0],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
              ? child
              : const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, error, stackTrace) {
            debugPrint("Error loading image: $error");
            return const Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  } else if (imageUrls.length == 2) {
    return SizedBox(
      height: 200,
      child: Row(
        children: imageUrls
            .asMap()
            .entries
            .map(
              (entry) => Expanded(
            child: GestureDetector(
              onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
              child: Container(
                margin: EdgeInsets.only(right: entry.key == 0 ? 1 : 0),
                child: Image.network(
                  entry.value,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  } else if (imageUrls.length == 3) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
              child: Image.network(
                imageUrls[0],
                fit: BoxFit.cover,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 0.5),
                      child: Image.network(
                        imageUrls[1],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.5),
                      child: Image.network(
                        imageUrls[2],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                      ),
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
    // For 4+ images
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(right: 0.5, bottom: 0.5),
                      child: Image.network(
                        imageUrls[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(left: 0.5, bottom: 0.5),
                      child: Image.network(
                        imageUrls[1],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                      ),
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
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(right: 0.5, top: 0.5),
                      child: Image.network(
                        imageUrls[2],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullImageView(imageUrls: imageUrls)),
                    child: Container(
                      margin: const EdgeInsets.only(left: 0.5, top: 0.5),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrls[3],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.error)),
                          ),
                          if (imageUrls.length > 4)
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  '+${imageUrls.length - 4}',
                                  style: h3.copyWith(
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
          else if (svgPath.contains('typing_icon') && postId != null) {
            Get.to(() => SharePostView(postId: postId));
          }
          else if (svgPath.contains('share_icon') && postId != null) {
            //Get.to(() => CommentsView(postId: postId));
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


class FullImageView extends StatelessWidget {
  final List<String> imageUrls;

  const FullImageView({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'View Images',
          style: h2.copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error, stackTrace) {
                debugPrint("Error loading image in FullImageView: $error");
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red, size: 50),
                );
              },
            ),
          );
        },
      ),
    );
  }
}