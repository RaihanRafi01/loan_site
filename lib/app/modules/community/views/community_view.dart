import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    // Avoid manual Get.put; rely on GetView's controller injection
    // If controller needs to be initialized, ensure it's done properly in the controller class
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            // Replaced AppBar with Container + Row
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
                    child: CustomTextField(
                      labelText: 'What’s on your mind',
                      controller: controller.statusController,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.grey[700]),
                    onPressed: () {},
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
                      'https://images.unsplash.com/photo-1486312338219-ce68e2c6b81d?w=400&h=300&fit=crop',
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
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Caption'),
          ),
          // Images grid
          _buildImageGrid(images),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActionButton(Icons.favorite_border, likes.toString()),
                const SizedBox(width: 24),
                _buildActionButton(Icons.chat_bubble_outline, comments.toString()),
                const SizedBox(width: 24),
                _buildActionButton(Icons.share_outlined, ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
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

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey[700],
        ),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}