import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import '../../../../common/widgets/community/communityDrawer.dart';
import '../../../../common/widgets/community/communityWidgets.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController()); // ensure controller available
    return Scaffold(
      backgroundColor: AppColors.appBc,
      endDrawer: buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: const NetworkImage(
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
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: SvgPicture.asset('assets/images/community/menu_icon.svg'),
                    ),
                  ),
                ],
              ),
            ),

            // Body: All posts (dynamic)
            Expanded(
              child: Obx(() {
                final posts = controller.allPosts;
                if (posts.isEmpty) {
                  // You can improve with a shimmer/empty state
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final username = post.user.name ?? 'User';
                    final userAvatar = post.user.image ?? 'https://via.placeholder.com/100';
                    final timeAgo = getTimeAgo(DateTime.tryParse(post.createdAt));
                    final content = post.content;
                    final images = (post.image != null && post.image!.isNotEmpty)
                        ? <String>[post.image!]
                        : const <String>[];

                    return _buildDynamicPostItem(
                      post: post,
                      username: username,
                      userAvatar: userAvatar,
                      timeAgo: timeAgo,
                      content: content,
                      images: images,
                      likes: post.likesCount,
                      comments: post.commentCount,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPostItem({
    required Post post,
    required String username,
    required String userAvatar,
    required String timeAgo,
    required String content,
    required List<String> images,
    required int likes,
    required int comments,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
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
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'not_interested',
                      child: Text('Not Interested'),
                    ),
                  ],
                  onChanged: (value) {
                    // TODO: implement "not interested" API if available
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

          // caption/content
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4),
              child: Text(
                content,
                style: h2.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
            ),

          // images
          buildImageGrid(images),
          const SizedBox(height: 16),

          // actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // inside _buildDynamicPostItem actions row
              buildActionButton(
                post.isLikedByUser
                    ? 'assets/images/community/love_icon_filled.svg'
                    : 'assets/images/community/love_icon.svg',
                post.likesCount.toString(),
                onPressed: () => controller.toggleLikeGlobal(post.id, post.isLikedByUser),
              ),

              buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
                postId: post.id,
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
}