import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/community_view.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart'; // Import the controller

class OwnProfileView extends GetView<CommunityController> {
  const OwnProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: controller.currentUser.value?.image != null
                        ? NetworkImage(controller.currentUser.value!.image!)
                        : const NetworkImage('https://via.placeholder.com/100'), // Placeholder
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${controller.currentUser.value?.name ?? 'User'}!',
                          style: h2.copyWith(
                            fontSize: 24,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          controller.currentUser.value?.email ?? '',
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.blurtext4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    fontSize: 14,
                    width: 120,
                    height: 36,
                    label: 'Create Post',
                    onPressed: () {
                      Get.to(const CreatePostView());
                    },
                    bgClr: [AppColors.cardSky, AppColors.cardSky],
                    txtClr: AppColors.appColor2,
                    svgPath: 'assets/images/community/plus_icon_blue.svg',
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: AppColors.dividerClr2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Post',
                    style: h3.copyWith(
                      fontSize: 20,
                      color: AppColors.textColor,
                    ),
                  ),
                  DropdownButton2<String>(
                    underline: Container(),
                    customButton: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardSky,
                        borderRadius: BorderRadius.circular(32), // Adjust the radius as needed
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Add padding
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/community/tic_blue.svg'),
                          const SizedBox(width: 8), // Optional: Add spacing between elements
                          Text(
                            'All',
                            style: h4.copyWith(color: AppColors.appColor2),
                          ),
                          const SizedBox(width: 8), // Optional: Add spacing between elements
                          SvgPicture.asset('assets/images/community/filter_icon.svg'),
                        ],
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'filter_all',
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/community/tic_icon.svg',
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'All',
                              style: h4.copyWith(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'filter_new',
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              'Newest',
                              style: h4.copyWith(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'filter_old',
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              'Oldest',
                              style: h4.copyWith(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      // TODO: Implement sorting based on value
                      print('Selected filter: $value');
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 150,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      elevation: 8,
                      offset: const Offset(0, -10),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.myPosts.length,
                itemBuilder: (context, index) {
                  final post = controller.myPosts[index];
                  return _buildPostItem(
                    username: post.user.name,
                    userAvatar: post.user.image ?? 'https://via.placeholder.com/100',
                    timeAgo: getTimeAgo(DateTime.parse(post.createdAt)),
                    content: post.content, // Dynamic content
                    images: post.image != null ? [post.image!] : [],
                    likes: post.likeCount,
                    comments: post.commentCount,
                    post: post, // Pass the post for like functionality
                    share: post.sharesCount
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
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

  Widget _buildPostItem({
    required String username,
    required String userAvatar,
    required String timeAgo,
    required String content,
    required List<String> images,
    required int likes,
    required int comments,
    required Post post,
    required int share,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
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
                          fontSize: 20,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: h4.copyWith(
                          fontSize: 16,
                          color: AppColors.gray10,
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton2<String>(
                  underline: Container(),
                  customButton: SvgPicture.asset(
                    'assets/images/community/three_dot_icon.svg',
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'edit_post',
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/community/tic_icon.svg',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Post',
                            style: h4.copyWith(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 'edit_post') {
                      print('Selected: Edit Post');
                      // TODO: Implement edit post functionality
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 150,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    elevation: 8,
                    offset: const Offset(0, -10),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4),
            child: Text(
              content,
              style: h2.copyWith(fontSize: 16, color: AppColors.textColor),
            ),
          ),
          CommunityView().buildImageGrid(images),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommunityView().buildActionButton(
                post.isLikedByUser ? 'assets/images/community/love_icon_filled.svg' : 'assets/images/community/love_icon.svg',
                likes.toString(),
                onPressed: () {
                  controller.toggleLike(post.id, post.isLikedByUser);
                },
              ),
              CommunityView().buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
                postId: post.id,
              ),
              CommunityView().buildActionButton(
                'assets/images/community/share_icon.svg',
                  share.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}