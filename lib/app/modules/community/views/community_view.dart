import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import 'package:loan_site/app/modules/community/views/message_view.dart';
import 'package:loan_site/app/modules/community/views/share_post_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_chat_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_view.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart';
import 'comments_view.dart';
import 'notification_chat_view.dart';
import 'own_profile_view.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      endDrawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Container + Row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostView(),
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.textInputField2,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'What’s on your mind',
                          style: h4.copyWith(
                            color: AppColors.blurtext2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: SvgPicture.asset('assets/images/community/menu_icon.svg'),
                    ),
                  ),
                ],
              ),
            ),
            // Body content
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section with Profile
          GestureDetector(
            onTap: ()=> Get.to(OwnProfileView()),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 43,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
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
                      ],)
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Divider(color: AppColors.dividerClr),
          ),

          const SizedBox(height: 20),

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _buildDrawerItem(
                    svgPath: 'assets/images/community/home_icon.svg',
                    title: 'Home',
                    isSelected: true,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  _buildDrawerItem(
                    svgPath: 'assets/images/community/message_icon.svg',
                    title: 'Message',
                    isSelected: false,
                    onTap: () {
                      Get.to(MessageView());
                    },
                  ),
                  _buildDrawerItem(
                    svgPath: 'assets/images/community/notification_icon.svg',
                    title: 'Notification',
                    isSelected: false,
                    onTap: () {
                      Get.to(NotificationCommunityView());
                    },
                  ),

                  const Spacer(),

                  // Bottom Contact Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 80,left: 20),
                    child: Column(
                      children: [
                        _buildContactItem(
                          svgPath: 'assets/images/community/call_icon.svg',
                          text: '+56994562587',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          svgPath: 'assets/images/community/mail_icon.svg',
                          text: 'angelo@gmail.com',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required String svgPath
  }) {
    return ListTile(
      leading: SvgPicture.asset(svgPath),
      title: Text(
        title,
        style: h3.copyWith(
          fontSize: 22,
          color: isSelected ? AppColors.appColor2 : AppColors.textColor10,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildContactItem({
    required String svgPath,
    required String text,
  }) {
    return Row(
      children: [
        SvgPicture.asset(svgPath),
        const SizedBox(width: 12),
        Text(
          text,
          style: h4.copyWith(
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
      ],
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
                      value: 'not_interested',
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/community/tic_icon.svg'),
                          const SizedBox(width: 8),
                          Text(
                            'Not Interested',
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
                    if (value == 'not_interested') {
                      print('Selected: Not Interested');
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 170,
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
          buildImageGrid(images),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildActionButton(
                'assets/images/community/love_icon.svg',
                likes.toString(),
              ),
              buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
              ),
              buildActionButton(
                'assets/images/community/typing_icon.svg',
                '',
              ),
              buildActionButton(
                'assets/images/community/share_icon.svg',
                '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImageGrid(List<String> images) {
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
    } else if (images.length >= 4) {
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
    return Container();
  }

  Widget buildActionButton(String svgPath, String count, {
    VoidCallback? onPressed,
    int? postId,
  }) {
    return GestureDetector(
      onTap: onPressed ?? () {
        // Check if this is the comment button
        if (svgPath.contains('comment_icon') && postId != null) {
          Get.to(() => CommentsView(postId: postId));
        }
        if(svgPath == 'assets/images/community/share_icon.svg'){
          Get.to(SharePostView());
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
      ),
    );
  }
}