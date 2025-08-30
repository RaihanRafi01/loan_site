import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';

// Add models
class User {
  final int id;
  final String name;
  final String email;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );
  }
}

class Comment {
  final int id;
  final int post;
  final User user;
  final String content;
  final int likesCount;
  final bool isLikedByUser;
  final String createdAt;
  final String updatedAt;

  Comment({
    required this.id,
    required this.post,
    required this.user,
    required this.content,
    required this.likesCount,
    required this.isLikedByUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      post: json['post'],
      user: User.fromJson(json['user']),
      content: json['content'],
      likesCount: json['likes_count'],
      isLikedByUser: json['is_liked_by_user'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Post {
  final int id;
  final User user;
  final String title;
  final String content;
  final String? image;
  final String? tags;
  final int likeCount;
  final int commentCount;
  final int likesCount;
  final int sharesCount;
  final bool isLikedByUser;
  final bool isSharedByUser;
  final bool isNotInterestedByUser;
  final List<Comment> comments;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    this.image,
    this.tags,
    required this.likeCount,
    required this.commentCount,
    required this.likesCount,
    required this.sharesCount,
    required this.isLikedByUser,
    required this.isSharedByUser,
    required this.isNotInterestedByUser,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      user: User.fromJson(json['user']),
      title: json['title'],
      content: json['content'],
      image: json['image'],
      tags: json['tags'],
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
      likesCount: json['likes_count'],
      sharesCount: json['shares_count'],
      isLikedByUser: json['is_liked_by_user'],
      isSharedByUser: json['is_shared_by_user'],
      isNotInterestedByUser: json['is_not_interested_by_user'],
      comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class CommunityController extends GetxController {
  final statusController = TextEditingController();
  final pickedMedia = RxList<File>([]);
  final isLoading = false.obs;

  final myPosts = RxList<Post>([]);
  final currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMyPosts();
  }

  void _showWarning(String message, {String title = 'Warning'}) {
    kSnackBar(
      title: title,
      message: message,
      bgColor: AppColors.snackBarWarning,
    );
  }

  Future<void> pickMedia() async {
    final picker = ImagePicker();
    final pickedFiles = await picker
        .pickMultipleMedia(); // Allows selecting multiple images/videos.
    if (pickedFiles.isNotEmpty) {
      pickedMedia.addAll(pickedFiles.map((f) => File(f.path)));
    }
  }

  Future<void> postContent() async {
    if (statusController.text.isEmpty && pickedMedia.isEmpty) {
      _showWarning('Please add some content or media before posting.');
      return;
    }

    isLoading.value = true;
    try {

      final body = jsonEncode({"title": "My First Post", "content": statusController.text});
      final response = await BaseClient.postRequest(
        api: Api.createPost,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post created successfully!');
        statusController.clear();
        pickedMedia.clear();
        // Refresh posts after creating a new one
        fetchMyPosts();
      } else {
        _showWarning('Failed to create post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Post error: $e');
      _showWarning('Failed to create post. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyPosts() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.myPosts, // Assuming Api.myPosts is defined in data/api.dart, e.g., static String myPosts = '/posts/my/';
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        myPosts.value = (data['results'] as List).map((e) => Post.fromJson(e)).toList();
        if (myPosts.isNotEmpty) {
          currentUser.value = myPosts[0].user;
        }
      } else {
        _showWarning('Failed to fetch posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Fetch posts error: $e');
      _showWarning('Failed to fetch posts. Please try again.');
    }
  }

  Future<void> toggleLike(int postId, bool currentlyLiked) async {
    try {
      final apiUrl = Api.likePost(postId.toString()); // Assuming Api.likePost = '/posts/{id}/like/'
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchMyPosts(); // Refresh to update like count and status
      } else {
        _showWarning('Failed to toggle like: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Toggle like error: $e');
      _showWarning('Failed to toggle like. Please try again.');
    }
  }

  Future<void> postComment(int postId, String content) async {
    if (content.trim().isEmpty) {
      _showWarning('Please enter a comment.');
      return;
    }

    try {
      final apiUrl = Api.createComment(postId.toString()); // Assuming Api.createComment = '/posts/{id}/comments/'
      final body = jsonEncode({"content": content});
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Comment added successfully!');
        fetchMyPosts(); // Refresh to update comments
      } else {
        _showWarning('Failed to add comment: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Post comment error: $e');
      _showWarning('Failed to add comment. Please try again.');
    }
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }
}