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
  final String? name;
  final String email;
  final String? image;

  User({
    required this.id,
    this.name,
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
  final RxInt likesCount;
  final RxBool isLikedByUser;
  final String createdAt;
  final String updatedAt;
  final int? parent;
  RxList<Comment> replies;

  Comment({
    required this.id,
    required this.post,
    required this.user,
    required this.content,
    required int likesCount,
    required bool isLikedByUser,
    required this.createdAt,
    required this.updatedAt,
    this.parent,
    RxList<Comment>? replies,
  }) : likesCount = likesCount.obs,
        isLikedByUser = isLikedByUser.obs,
        replies = replies ?? RxList<Comment>();

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
      parent: json['parent'],
      replies: (json['replies'] as List? ?? []).map((e) => Comment.fromJson(e)).toList().obs,
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
  int likeCount;
  int commentCount;
  int likesCount;
  final int sharesCount;
  bool isLikedByUser;
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
    List<dynamic> commentJsons = json['comments'] as List;
    List<Comment> topLevelComments = commentJsons
        .where((cJson) => cJson['parent'] == null)
        .map((cJson) => Comment.fromJson(cJson))
        .toList();

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
      comments: topLevelComments,
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
  final currentReplies = RxList<Comment>([]);
  final currentComment = Rx<Comment?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMyPosts();
  }

  void updateReplies(Comment comment) {
    // Find the comment in the posts list and update its replies
    final post = myPosts.firstWhere((p) => p.id == comment.post);
    final updatedComment = post.comments.firstWhere((c) => c.id == comment.id);
    updatedComment.replies = comment.replies;  // Update the replies in the comment
    myPosts.refresh();  // Trigger reactivity to update the UI
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
    final pickedFiles = await picker.pickMultipleMedia();
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
        final newPostData = jsonDecode(response.body);
        final newPost = Post.fromJson(newPostData);
        myPosts.insert(0, newPost);
        myPosts.refresh();
        if (currentUser.value == null) {
          currentUser.value = newPost.user;
        }
        Get.snackbar('Success', 'Post created successfully!');
        statusController.clear();
        pickedMedia.clear();
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
        api: Api.myPosts,
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
    final post = myPosts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    // Optimistic update
    final oldLiked = post.isLikedByUser;
    final oldLikes = post.likesCount;
    post.isLikedByUser = !currentlyLiked;
    post.likesCount += currentlyLiked ? -1 : 1;
    post.likeCount = post.likesCount; // If likeCount is alias
    myPosts.refresh();

    try {
      final apiUrl = Api.likePost(postId.toString());
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        // Revert on failure
        post.isLikedByUser = oldLiked;
        post.likesCount = oldLikes;
        post.likeCount = oldLikes;
        myPosts.refresh();
        _showWarning('Failed to toggle like: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Revert on error
      post.isLikedByUser = oldLiked;
      post.likesCount = oldLikes;
      post.likeCount = oldLikes;
      myPosts.refresh();
      print('Toggle like error: $e');
      _showWarning('Failed to toggle like. Please try again.');
    }
  }

  Future<void> toggleLikeComment(int commentId, bool currentlyLiked) async {
    try {
      final comment = _findCommentById(commentId);
      if (comment != null) {
        comment.isLikedByUser.value = !currentlyLiked;
        comment.likesCount.value += currentlyLiked ? -1 : 1;
      }

      final apiUrl = Api.likeComment(commentId.toString());
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API call successful, local state already updated
      } else {
        if (comment != null) {
          comment.isLikedByUser.value = currentlyLiked;
          comment.likesCount.value += currentlyLiked ? 1 : -1;
        }
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

    final post = myPosts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    try {
      final apiUrl = Api.createComment(postId.toString());
      final body = jsonEncode({"content": content});
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newCommentData = jsonDecode(response.body);
        final newComment = Comment.fromJson(newCommentData);
        post.comments.add(newComment);
        post.commentCount += 1;
        myPosts.refresh();
        Get.snackbar('Success', 'Comment added successfully!');
      } else {
        _showWarning('Failed to add comment: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Post comment error: $e');
      _showWarning('Failed to add comment. Please try again.');
    }
  }

  Future<void> postReply(int commentId, String content) async {
    if (content.trim().isEmpty) {
      _showWarning('Please enter a reply.');
      return;
    }

    final parentComment = _findCommentById(commentId);
    if (parentComment == null) return;

    try {
      final apiUrl = Api.commentReplies(commentId.toString());
      final body = jsonEncode({"content": content});
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newReplyData = jsonDecode(response.body);
        final newReply = Comment.fromJson(newReplyData);
        parentComment.replies.add(newReply);
        if (currentComment.value != null && currentComment.value!.id == commentId) {
          currentReplies.add(newReply);
        }
        Get.snackbar('Success', 'Reply added successfully!');
      } else {
        _showWarning('Failed to add reply: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Post reply error: $e');
      _showWarning('Failed to add reply. Please try again.');
    }
  }

  Comment? _findCommentById(int commentId) {
    for (final post in myPosts) {
      for (final comment in post.comments) {
        if (comment.id == commentId) return comment;
        for (final reply in comment.replies) {
          if (reply.id == commentId) return reply;
        }
      }
    }
    return null;
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }
}