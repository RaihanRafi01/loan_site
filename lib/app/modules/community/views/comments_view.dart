import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loan_site/app/modules/community/views/reply_view.dart';
import 'package:loan_site/app/modules/community/views/share_post_view.dart';
import 'dart:convert';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/community/communityWidgets.dart';
import '../controllers/community_controller.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class CommentsView extends GetView<CommunityController> {
  final int postId;
  final TextEditingController _commentController = TextEditingController();

  CommentsView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Post?>(
        future: controller.fetchPostIfNeeded(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load post'));
          }

          final post = snapshot.data!;
          final username = post.user.name ?? 'Anonymous';
          final userAvatar = post.user.image ?? 'https://via.placeholder.com/100';
          final timeAgo = getTimeAgo(DateTime.parse(post.createdAt));
          final likes = post.likeCount;
          final comments = post.commentCount;
          final content = post.content;

          final images = post.images
              .where((imageData) => imageData.image != null && imageData.image.isNotEmpty)
              .map((imageData) => {'image': imageData.image})
              .toList();

          return Column(
            children: [
              // Original Post
              Container(
                color: AppColors.appBc,
                child: _buildOriginalPost(post, username, userAvatar, timeAgo, content, images, likes, comments),
              ),

              // Comments Section Header
              Container(
                color: AppColors.appBc,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      'Comments',
                      style: h4.copyWith(
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),

            // Comments List
            Expanded(
              child: Container(
                color: AppColors.appBc,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    return _buildCommentItem(post.comments[index]);
                  },
                ),
              ),
            ),

              // Comment Input
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
                child: _buildCommentInput(),
              ),
            ],
          );
        },
      ),
    );
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).abs();
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  Widget _buildOriginalPost(Post post, String username, String userAvatar, String timeAgo, String content, List<Map<String, dynamic>> images, int likes, int comments) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: h3.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: h4.copyWith(fontSize: 14, color: AppColors.gray10),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Caption
          Text(
            content,
            style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
          ),

          const SizedBox(height: 12),

          // Images
          buildImageGrid(images),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  controller.toggleLike(post.id, post.isLikedByUser);
                },
                child: _buildActionButton(
                  post.isLikedByUser ? 'assets/images/community/love_icon_filled.svg' : 'assets/images/community/love_icon.svg',
                  likes.toString(),
                ),
              ),
              _buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => SharePostView(postId: post.id));
                },
                child: _buildActionButton('assets/images/community/typing_icon.svg', ''),
              ),
              GestureDetector(
                onTap: () {
                  //Get.to(() => SharePostView(postId: post.id));
                },
                child: _buildActionButton('assets/images/community/share_icon.svg', ''),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.user.image ?? 'https://via.placeholder.com/100'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.name ?? 'Anonymous',
                  style: h2.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: h4.copyWith(fontSize: 16, color: AppColors.textColor11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      getTimeAgo(DateTime.parse(comment.createdAt)),
                      style: h3.copyWith(fontSize: 12, color: AppColors.gray10),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => GestureDetector(
                      onTap: () {
                        controller.toggleLikeComment(comment.id, comment.isLikedByUser.value);
                      },
                      child: _buildActionButton(
                        comment.isLikedByUser.value ? 'assets/images/community/love_icon_filled.svg' : 'assets/images/community/love_icon.svg',
                        comment.likesCount.toString(),
                      ),
                    )),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ReplyView(comment: comment));
                      },
                      child: Text(
                        'Reply',
                        style: h3.copyWith(
                          fontSize: 12,
                          color: AppColors.gray10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Camera button
          SvgPicture.asset('assets/images/home/cam_icon.svg'),
          const SizedBox(width: 8),
          // Image/Gallery button
          SvgPicture.asset('assets/images/home/image_icon.svg'),
          const SizedBox(width: 12),
          // Text input field with mic icon
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.chatInput,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: InputBorder.none,
                        hintStyle: h4.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  SvgPicture.asset('assets/images/home/mic_icon.svg'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          GestureDetector(
              onTap: _addComment,
              child: SvgPicture.asset('assets/images/home/send_icon.svg')),
        ],
      ),
    );
  }

  void _addComment() {
    controller.postComment(postId, _commentController.text);
    _commentController.clear();
  }

  Widget _buildActionButton(String svgPath, String count) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: AppColors.cardSky,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
            ),
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
    );
  }
}