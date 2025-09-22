import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/create_post_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/community/communityWidgets.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/community_controller.dart';
import 'editPost_view.dart';

class OwnProfileView extends GetView<CommunityController> {
  const OwnProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    final ScrollController scrollController = ScrollController();
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMoreMyPosts.value &&
          controller.hasMoreMyPosts.value) {
        controller.fetchMyPosts(isLoadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          dashboardController.profileImageUrl.value != null &&
                              dashboardController
                                  .profileImageUrl
                                  .value
                                  .isNotEmpty
                          ? NetworkImage(
                              dashboardController.profileImageUrl.value,
                            )
                          : const AssetImage(
                                  'assets/images/community/default_user.png',
                                )
                                as ImageProvider,
                      onBackgroundImageError: (_, __) => const AssetImage(
                        'assets/images/community/default_user.png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${dashboardController.name ?? 'User'}!',
                            style: h2.copyWith(
                              fontSize: 24,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                    customButton: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardSky,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/community/tic_blue.svg',
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              controller.selectedMyPostFilter.value ==
                                      'filter_all'
                                  ? 'All'
                                  : controller.selectedMyPostFilter.value ==
                                        'filter_new'
                                  ? 'Newest'
                                  : 'Oldest',
                              style: h4.copyWith(color: AppColors.appColor2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            'assets/images/community/filter_icon.svg',
                          ),
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
                      if (value != null) {
                        controller.applyMyPostSort(value);
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
              child: Obx(() {
                if (controller.isInitialLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = controller.myPosts;
                if (posts.isEmpty) {
                  return Center(
                    child: Text(
                      'No posts found',
                      style: h4.copyWith(fontSize: 16, color: AppColors.gray12),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount:
                      posts.length +
                      (posts.isNotEmpty &&
                              (controller.isLoadingMoreMyPosts.value ||
                                  controller.hasMoreMyPosts.value)
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index == posts.length && posts.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: controller.isLoadingMoreMyPosts.value
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
                    final timeAgo = getTimeAgo(
                      DateTime.tryParse(post.createdAt),
                    );
                    final content = post.content;
                    final images = post.images
                        .where(
                          (imageData) =>
                              imageData.image != null &&
                              imageData.image.isNotEmpty,
                        )
                        .map((imageData) => {'image': imageData.image})
                        .toList();

                    return _buildPostItem(
                      username: username,
                      userAvatar: userAvatar,
                      timeAgo: timeAgo,
                      content: content,
                      images: images,
                      likes: post.likeCount,
                      comments: post.commentCount,
                      post: post,
                      share: post.sharesCount,
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

  Widget _buildPostItem({
    required String username,
    required String userAvatar,
    required String timeAgo,
    required String content,
    required List<Map<String, dynamic>> images,
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
                  backgroundImage: userAvatar.isNotEmpty
                      ? NetworkImage(userAvatar)
                      : const AssetImage(
                              'assets/images/community/default_user.png',
                            )
                            as ImageProvider,
                  onBackgroundImageError: (_, __) => const AssetImage(
                    'assets/images/community/default_user.png',
                  ),
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
                      Get.to(() => EditPostView(post: post));
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
                likes.toString(),
                onPressed: () {
                  controller.toggleLikeGlobal(post.id, post.isLikedByUser);
                },
              ),
              buildActionButton(
                'assets/images/community/comment_icon.svg',
                comments.toString(),
                postId: post.id,
              ),
              buildActionButton(
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
