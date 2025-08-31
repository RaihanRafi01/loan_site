import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart';

class ReplyView extends GetView<CommunityController> {
  final Comment comment;
  final TextEditingController _replyController = TextEditingController();

  ReplyView({super.key, required this.comment});

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
          'Replies',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Original Comment
          Container(
            color: AppColors.appBc,
            padding: const EdgeInsets.all(16),
            child: _buildCommentItem(comment),
          ),

          // Replies Section Header
          Container(
            color: AppColors.appBc,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Text(
                  'Replies',
                  style: h4.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),

          // Replies List
          Expanded(
            child: Container(
              color: AppColors.appBc,
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: comment.replies.length,
                  itemBuilder: (context, index) {
                    return _buildReplyItem(comment.replies[index]);
                  },
                );
              }),
            ),
          ),

          // Reply Input
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: _buildReplyInput(),
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
                    Text(
                      'React',
                      style: h3.copyWith(
                        fontSize: 12,
                        color: AppColors.gray10,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: h3.copyWith(
                        fontSize: 12,
                        color: AppColors.gray10,
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

  Widget _buildReplyItem(Comment reply) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(reply.user.image ?? 'https://via.placeholder.com/100'),
          ),
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
                    Text(
                      'React',
                      style: h3.copyWith(
                        fontSize: 12,
                        color: AppColors.gray10,
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

  Widget _buildReplyInput() {
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
                      controller: _replyController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Type your reply...',
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
            onTap: _addReply,
            child: SvgPicture.asset('assets/images/home/send_icon.svg'),
          ),
        ],
      ),
    );
  }

  void _addReply() async {
    // Ensure that the reply text is not empty
    if (_replyController.text.trim().isEmpty) {
     /* _showWarning('Please enter a reply.');*/
      return; // Do not proceed if the reply is empty
    }

    // Get the content of the reply
    final replyContent = _replyController.text.trim();

    // Posting the reply to the server
    await controller.postReply(comment.id, replyContent);

    // Assuming postReply successfully updates the comment and its replies in the backend
    final newReply = Comment(
      id: -1, // Use an id or placeholder; this can be updated from the response if available
      post: comment.post,
      user: controller.currentUser.value!, // Assuming the current user is available
      content: replyContent,
      likesCount: 0,
      isLikedByUser: false,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      replies: RxList<Comment>(),  // Initialize replies as an empty RxList
    );

    // Manually updating the local `comment.replies` list with the new reply
    comment.replies.add(newReply);

    // Clear the input field after adding the reply
    _replyController.clear();

    // Since GetX is reactive, this should automatically update the UI
    controller.updateReplies(comment); // This triggers reactivity to update the UI

    // Optionally, you can also fetch updated posts if needed
    // await controller.fetchMyPosts();
  }


}
