import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/community_view.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class OwnProfileView extends GetView {
  const OwnProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello Angelo!',
                          style: h2.copyWith(
                            fontSize: 24,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          'zanlee@gmail.com',
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
                      Get.to(CreatePostView());
                    },
                    bgClr: [AppColors.cardSky, AppColors.cardSky],
                    txtClr: AppColors.appColor2,
                    svgPath: 'assets/images/community/plus_icon_blue.svg',
                  ),
                ],
              ),
            ),
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
                    customButton: /*CustomButton(
                      fontSize: 14,
                      width: 100,
                      height: 36,
                      label: 'All',
                      onPressed: () {},
                      bgClr: [AppColors.cardSky, AppColors.cardSky],
                      txtClr: AppColors.appColor2,
                      svgPath: 'assets/images/community/tic_blue.svg',
                      svgPath2: 'assets/images/community/filter_icon.svg',
                    )*/Container(
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
                              'Edit Post',
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
                              'Edit Post',
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
                        print('Selected: Not Interested');
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
            Expanded(
              child: ListView(
                children: [
                  _buildPostItem(
                    username: 'Cleve',
                    userAvatar:
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                    timeAgo: '2h',
                    images: [
                      'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=300&fit=crop',
                      'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=300&fit=crop',
                      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=400&h=300&fit=crop',
                      'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=400&h=300&fit=crop',
                    ],
                    likes: 101,
                    comments: 101,
                  ),
                  _buildPostItem(
                    username: 'Cleve',
                    userAvatar:
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                    timeAgo: '4h',
                    images: [
                      'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&h=300&fit=crop',
                      'https://images.unsplash.com/photo-1497366412874-3415097a27e7?w=400&h=300&fit=crop',
                      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=400&h=300&fit=crop',
                    ],
                    likes: 87,
                    comments: 23,
                  ),
                  _buildPostItem(
                    username: 'Cleve',
                    userAvatar:
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                    timeAgo: '6h',
                    images: [
                      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=600&fit=crop',
                    ],
                    likes: 142,
                    comments: 56,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostItem({
    required String username,
    required String userAvatar,
    required String timeAgo,
    required List<String> images,
    required int likes,
    required int comments,
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
                      print('Selected: Not Interested');
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
              'Caption',
              style: h2.copyWith(fontSize: 16, color: AppColors.textColor),
            ),
          ),
          CommunityView().buildImageGrid(images),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommunityView().buildActionButton(
                'assets/images/community/love_icon.svg',
                likes.toString(),
              ),
              CommunityView().buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
                username: username,
                userAvatar: userAvatar,
                timeAgo: timeAgo,
                images: images,
                likes: likes,
                comments: comments,
              ),
              CommunityView().buildActionButton(
                'assets/images/community/share_icon.svg',
                '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
