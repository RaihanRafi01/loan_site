import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/reply_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class CommentsView extends StatefulWidget {
  final String username;
  final String userAvatar;
  final String timeAgo;
  final List<String> images;
  final int likes;
  final int comments;

  const CommentsView({
    super.key,
    required this.username,
    required this.userAvatar,
    required this.timeAgo,
    required this.images,
    required this.likes,
    required this.comments,
  });

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'name': 'Sam Lee',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      'comment':
          'Lorem ipsum dolor sit amet consectetur. Lobortis mauris mi vel vel vulputate netus in vel.',
      'timeAgo': '1hr ago',
    },
    {
      'name': 'Sam Lee',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      'comment':
          'Lorem ipsum dolor sit amet consectetur. Lobortis mauris mi vel vel vulputate netus in vel.',
      'timeAgo': '1hr ago',
    },
    {
      'name': 'Sam Lee',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      'comment':
          'Lorem ipsum dolor sit amet consectetur. Lobortis mauris mi vel vel vulputate netus in vel.',
      'timeAgo': '1hr ago',
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
          'Comments',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Original Post
          Container(color: AppColors.appBc, child: _buildOriginalPost()),

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
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return _buildCommentItem(_comments[index]);
                },
              ),
            ),
          ),

          // Comment Input
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 6),
            child: _buildCommentInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalPost() {
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
                backgroundImage: NetworkImage(widget.userAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: h3.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.timeAgo,
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
            'Caption',
            style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
          ),

          const SizedBox(height: 12),

          // Images
          _buildImageGrid(widget.images),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                'assets/images/community/love_icon.svg',
                widget.likes.toString(),
              ),
              _buildActionButton(
                'assets/images/community/comment_icon.svg',
                widget.comments.toString(),
              ),
              _buildActionButton('assets/images/community/typing_icon.svg', ''),
              _buildActionButton('assets/images/community/share_icon.svg', ''),
            ],
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReplyView(comment: comment),
                          ),
                        );
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
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'name': 'You',
          'avatar':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
          'comment': _commentController.text.trim(),
          'timeAgo': 'now',
        });
      });
      _commentController.clear();
    }
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                ? child
                : const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      );
    } else if (images.length == 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 150,
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
                            loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else if (images.length >= 3) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  images[0],
                  fit: BoxFit.cover,
                  height: double.infinity,
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 0.5),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(images[2], fit: BoxFit.cover),
                            if (images.length > 3)
                              Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Text(
                                    '+${images.length - 3}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
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
        ),
      );
    }
    return Container();
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
