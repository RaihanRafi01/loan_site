import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class ReplyView extends StatefulWidget {
  final Map<String, dynamic> comment;

  const ReplyView({super.key, required this.comment});

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView> {
  final TextEditingController _replyController = TextEditingController();
  final List<Map<String, dynamic>> _replies = [
    // Sample replies (you can replace this with actual reply data)
    {
      'name': 'Jane Doe',
      'avatar':
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
      'comment': 'This is a sample reply to the comment.',
      'timeAgo': '30m ago',
    },
  ];

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
            child: _buildCommentItem(widget.comment),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _replies.length,
                itemBuilder: (context, index) {
                  return _buildReplyItem(_replies[index]);
                },
              ),
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

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment['avatar']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['name'],
                  style: h2.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment['comment'],
                  style: h4.copyWith(fontSize: 16, color: AppColors.textColor11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      comment['timeAgo'],
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

  Widget _buildReplyItem(Map<String, dynamic> reply) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(reply['avatar']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply['name'],
                  style: h2.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reply['comment'],
                  style: h4.copyWith(fontSize: 16, color: AppColors.textColor11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      reply['timeAgo'],
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

  void _addReply() {
    if (_replyController.text.trim().isNotEmpty) {
      setState(() {
        _replies.insert(0, {
          'name': 'You',
          'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
          'comment': _replyController.text.trim(),
          'timeAgo': 'now',
        });
      });
      _replyController.clear();
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}