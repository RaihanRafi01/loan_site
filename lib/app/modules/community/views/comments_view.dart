import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/reply_view.dart';
import 'package:loan_site/app/modules/community/views/share_post_view.dart';
import 'dart:convert';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/community/communityWidgets.dart';
import '../../../../common/widgets/community/speechToTextButton.dart';
import '../../../core/services/stt_service.dart';
import '../../../core/utils/image_utils.dart';
import '../controllers/community_controller.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class CommentsView extends GetView<CommunityController> {
  final int postId;
  final TextEditingController _commentController = TextEditingController();
  final SpeechToTextService _speechService = SpeechToTextService();

  CommentsView({
    super.key,
    required this.postId,
  });

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

  @override
  void dispose() {
    _commentController.dispose();
    _speechService.dispose();
  }

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
          final userAvatar = ImageUtils.getImageUrl(post.user.image);
          final timeAgo = getTimeAgo(DateTime.parse(post.createdAt));
          final content = post.content;

          final images = post.images
              .where((imageData) => imageData.image != null && imageData.image.isNotEmpty)
              .map((imageData) => {'image': imageData.image})
              .toList();

          return Column(
            children: [
              Container(
                color: AppColors.appBc,
                child: _buildOriginalPost(post, username, userAvatar, timeAgo, content, images),
              ),
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
              Expanded(
                child: Obx(() {
                  final updatedPost = controller.allPosts.firstWhereOrNull((p) => p.id == postId) ?? post;
                  return Container(
                    color: AppColors.appBc,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: updatedPost.comments.length,
                      itemBuilder: (context, index) {
                        final comment = updatedPost.comments[index];
                        return _buildCommentItem(comment);
                      },
                    ),
                  );
                }),
              ),
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

  Widget _buildOriginalPost(Post post, String username, String userAvatar, String timeAgo, String content, List<Map<String, dynamic>> images) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageUtils.buildAvatar(userAvatar),
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
          Text(
            content,
            style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
          ),
          const SizedBox(height: 12),
          buildImageGrid(images),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final currentPost = controller.allPosts.firstWhereOrNull((p) => p.id == post.id) ?? post;
                return GestureDetector(
                  onTap: () {
                    controller.toggleLikeGlobal(currentPost.id, currentPost.isLikedByUser);
                  },
                  child: _buildActionButton(
                    currentPost.isLikedByUser
                        ? 'assets/images/community/love_icon_filled.svg'
                        : 'assets/images/community/love_icon.svg',
                    currentPost.likesCount.toString(),
                  ),
                );
              }),
              Obx(() {
                final currentPost = controller.allPosts.firstWhereOrNull((p) => p.id == post.id) ?? post;
                return _buildActionButton(
                  'assets/images/community/comment_icon.svg',
                  currentPost.commentCount.toString(),
                );
              }),
              GestureDetector(
                onTap: () {
                  Get.to(() => SharePostView(postId: post.id));
                },
                child: _buildActionButton('assets/images/community/typing_icon.svg', ''),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => SharePostView(postId: post.id));
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUtils.buildAvatar(ImageUtils.getImageUrl(comment.user.image)),
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
                            comment.isLikedByUser.value
                                ? 'assets/images/community/love_icon_filled.svg'
                                : 'assets/images/community/love_icon.svg',
                            comment.likesCount.value.toString(),
                          ),
                        )),
                        if (comment.replies.length < 2) ...[
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            if (comment.replies.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comment.replies.length,
                itemBuilder: (context, index) {
                  final reply = comment.replies[index];
                  return _buildReplyItem(reply);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReplyItem(Comment reply) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageUtils.buildAvatar(ImageUtils.getImageUrl(reply.user.image)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.user.name ?? 'Anonymous',
                  style: h2.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reply.content,
                  style: h4.copyWith(fontSize: 16, color: AppColors.textColor11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      getTimeAgo(DateTime.parse(reply.createdAt)),
                      style: h3.copyWith(fontSize: 12, color: AppColors.gray10),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => GestureDetector(
                      onTap: () {
                        controller.toggleLikeComment(reply.id, reply.isLikedByUser.value);
                      },
                      child: _buildActionButton(
                        reply.isLikedByUser.value
                            ? 'assets/images/community/love_icon_filled.svg'
                            : 'assets/images/community/love_icon.svg',
                        reply.likesCount.value.toString(),
                      ),
                    )),
                    if (reply.replies.isEmpty) ...[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ReplyView(comment: reply));
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
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  SpeechToTextButton(
                    speechService: _speechService,
                    controller: _commentController,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _addComment,
            child: SvgPicture.asset('assets/images/home/send_icon.svg'),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      controller.postComment(postId, _commentController.text);
      _commentController.clear();
    }
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