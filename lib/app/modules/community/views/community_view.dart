import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import '../../../../common/widgets/community/communityDrawer.dart';
import '../../../../common/widgets/community/communityWidgets.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    final ScrollController scrollController = ScrollController();
    final DashboardController dashboardController = Get.find<DashboardController>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMoreAllPosts.value &&
          controller.hasMoreAllPosts.value) {
        controller.fetchAllPosts(isLoadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.appBc,
      endDrawer: buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: dashboardController.profileImageUrl.value != null &&
                        dashboardController.profileImageUrl.value.isNotEmpty
                        ? NetworkImage(dashboardController.profileImageUrl.value)
                        : const AssetImage('assets/images/community/default_user.png') as ImageProvider,
                    onBackgroundImageError: (_, __) =>
                    const AssetImage('assets/images/community/default_user.png'),
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
            Expanded(
              child: Obx(() {
                if (controller.isInitialLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = controller.allPosts;
                if (posts.isEmpty) {
                  return Center(
                    child: Text(
                      'No posts found',
                      style: h4.copyWith(
                        fontSize: 16,
                        color: AppColors.gray12,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: posts.length + (posts.isNotEmpty && (controller.isLoadingMoreAllPosts.value || controller.hasMoreAllPosts.value) ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == posts.length && posts.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: controller.isLoadingMoreAllPosts.value
                              ? const CircularProgressIndicator()
                              : Text(
                            'No more posts',
                            style: h4.copyWith(
                              fontSize: 16,
                              color: AppColors.gray12,
                            ),
                          ),
                        ),
                      );
                    }
                    final post = posts[index];
                    final username = post.user.name ?? 'User';
                    final userAvatar = post.user.image ?? '';
                    final timeAgo = getTimeAgo(DateTime.tryParse(post.createdAt));
                    final content = post.content;
                    final images = post.images
                        .where((imageData) => imageData.image != null && imageData.image.isNotEmpty)
                        .map((imageData) => {'image': imageData.image})
                        .toList();

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
    required List<Map<String, dynamic>> images,
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
                  backgroundImage: userAvatar.isNotEmpty
                      ? NetworkImage(userAvatar)
                      : const AssetImage('assets/images/community/default_user.png') as ImageProvider,
                  onBackgroundImageError: (_, __) => const AssetImage('assets/images/community/default_user.png'),
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
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4),
              child: Text(
                content,
                style: h2.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
            ),
          buildImageGrid(images),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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