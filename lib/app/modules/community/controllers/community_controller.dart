import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class User {
  final int id;
  final String? name;
  final String email;
  final String? image;

  User({required this.id, this.name, required this.email, this.image});

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
    var replies = (json['replies'] as List? ?? [])
        .map((e) => Comment.fromJson(e))
        .toList()
        .obs;

    // Limit replies to only one level (replies to replies, no deeper)
    replies = replies.where((reply) => reply.parent != null).toList().obs;

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
      replies: replies,
    );
  }
}

class ImageData {
  final int id;
  final int post;
  final String image;

  ImageData({required this.id, required this.post, required this.image});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'] ?? 0,
      post: json['post'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}

class Post {
  final int id;
  final User user;
  String title;
  String content;
  List<ImageData> images;
  String? tags;
  int likeCount;
  int commentCount;
  int likesCount;
  final int sharesCount;
  bool isLikedByUser;
  final bool isSharedByUser;
  bool isNotInterestedByUser;
  final List<Comment> comments;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.images,
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
    List<dynamic> commentJsons = json['comments'] as List? ?? [];
    List<Comment> topLevelComments = commentJsons
        .where((cJson) => cJson['parent'] == null)
        .map((cJson) => Comment.fromJson(cJson))
        .toList();

    List<ImageData> images = (json['images'] as List? ?? [])
        .where((imageData) => imageData != null && imageData is Map<String, dynamic>)
        .map((imageData) => ImageData.fromJson(imageData as Map<String, dynamic>))
        .toList();

    final user = json['user'] != null
        ? User.fromJson(json['user'])
        : User(id: 0, email: '', name: null, image: null);

    return Post(
      id: json['id'] ?? 0,
      user: user,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      images: images,
      tags: json['tags'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      isLikedByUser: json['is_liked_by_user'] ?? false,
      isSharedByUser: json['is_shared_by_user'] ?? false,
      isNotInterestedByUser: json['is_not_interested_by_user'] ?? false,
      comments: topLevelComments,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class CommunityController extends GetxController {
  final statusController = TextEditingController();
  final pickedMedia = RxList<File>([]);
  final isLoading = false.obs;

  final allPosts = RxList<Post>([]);
  final myPosts = RxList<Post>([]);
  final currentUser = Rx<User?>(null);
  final currentReplies = RxList<Comment>([]);
  final currentComment = Rx<Comment?>(null);

  final selectedMyPostFilter = 'filter_all'.obs;
  final nextUrlAllPosts = RxString('');
  final nextUrlMyPosts = RxString('');
  final isLoadingMoreAllPosts = false.obs;
  final isLoadingMoreMyPosts = false.obs;
  final hasMoreAllPosts = true.obs;
  final hasMoreMyPosts = true.obs;
  final isInitialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
    fetchMyPosts();
  }

  Future<Post?> fetchPostIfNeeded(int postId) async {
    final post = allPosts.firstWhereOrNull((p) => p.id == postId);
    if (post != null) {
      return post;
    }

    try {
      final apiUrl = Api.fetchPost(postId);
      final response = await BaseClient.getRequest(
        api: apiUrl,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedPost = Post.fromJson(data);
        allPosts.add(fetchedPost);
        return fetchedPost;
      } else {
        throw Exception('Failed to fetch post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Fetch post error: $e');
      return null;
    }
  }

  Future<void> fetchAllPosts({bool isLoadMore = false}) async {
    if (isLoadMore && (!hasMoreAllPosts.value || isLoadingMoreAllPosts.value))
      return;

    try {
      isLoadingMoreAllPosts.value = true;
      if (!isLoadMore) isInitialLoading.value = true;
      final response = await BaseClient.getRequest(
        api: isLoadMore ? nextUrlAllPosts.value : Api.allPosts,
        headers: BaseClient.authHeaders(),
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final List<dynamic> list = data['results'] ?? [];
          final newPosts = list
              .map((e) {
                if (e is Map<String, dynamic>) {
                  return Post.fromJson(e);
                }
                print('Invalid item found: $e');
                return null;
              })
              .whereType<Post>()
              .toList();

          if (isLoadMore) {
            allPosts.addAll(newPosts);
          } else {
            allPosts.assignAll(newPosts);
          }

          nextUrlAllPosts.value = data['next'] ?? '';
          hasMoreAllPosts.value = data['next'] != null;

          if (currentUser.value == null && myPosts.isNotEmpty) {
            currentUser.value = myPosts.first.user;
          }
        } else {
          _showWarning('Unexpected response format. The data is not a Map.');
        }
      } else {
        _showWarning('Failed to fetch all posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Fetch all posts error: $e');
      _showWarning('Failed to fetch all posts. Please try again.');
      if (!isLoadMore) {
        allPosts.clear();
      }
    } finally {
      isLoadingMoreAllPosts.value = false;
      isInitialLoading.value = false;
    }
  }

  Future<void> fetchMyPosts({bool isLoadMore = false}) async {
    if (isLoadMore && (!hasMoreMyPosts.value || isLoadingMoreMyPosts.value))
      return;

    try {
      isLoadingMoreMyPosts.value = true;
      final response = await BaseClient.getRequest(
        api: isLoadMore ? nextUrlMyPosts.value : Api.myPosts,
        headers: BaseClient.authHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final List<dynamic> list = data['results'] ?? [];
          final newPosts = list
              .map((e) {
                if (e is Map<String, dynamic>) {
                  return Post.fromJson(e);
                }
                print('Invalid item found: $e');
                return null;
              })
              .whereType<Post>()
              .toList();

          if (isLoadMore) {
            myPosts.addAll(newPosts);
          } else {
            myPosts.assignAll(newPosts);
          }

          nextUrlMyPosts.value = data['next'] ?? '';
          hasMoreMyPosts.value = data['next'] != null;

          if (currentUser.value == null && newPosts.isNotEmpty) {
            currentUser.value = newPosts.first.user;
          }
        } else {
          _showWarning('Unexpected response format. The data is not a Map.');
        }
      } else {
        _showWarning('Failed to fetch my posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Fetch my posts error: $e');
      _showWarning('Failed to fetch my posts. Please try again.');
      if (!isLoadMore) {
        myPosts.clear();
      }
    } finally {
      isLoadingMoreMyPosts.value = false;
    }
  }

  Future<void> toggleLikeGlobal(int postId, bool currentlyLiked) async {
    Post? _touch(List<Post> list) {
      final p = list.firstWhereOrNull((e) => e.id == postId);
      if (p != null) {
        final oldLiked = p.isLikedByUser;
        final oldLikes = p.likesCount;
        p.isLikedByUser = !currentlyLiked;
        p.likesCount += currentlyLiked ? -1 : 1;
        p.likeCount = p.likesCount;
        return Post(
          id: p.id,
          user: p.user,
          title: p.title,
          content: p.content,
          images: p.images,
          tags: p.tags,
          likeCount: oldLikes,
          commentCount: p.commentCount,
          likesCount: oldLikes,
          sharesCount: p.sharesCount,
          isLikedByUser: oldLiked,
          isSharedByUser: p.isSharedByUser,
          isNotInterestedByUser: p.isNotInterestedByUser,
          comments: p.comments,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
        );
      }
      return null;
    }

    final backupMy = _touch(myPosts);
    final backupAll = _touch(allPosts);
    myPosts.refresh();
    allPosts.refresh();

    try {
      final apiUrl = Api.likePost(postId.toString());
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      final ok = response.statusCode == 200 || response.statusCode == 201;
      if (!ok) {
        if (backupMy != null) {
          final p = myPosts.firstWhereOrNull((e) => e.id == postId);
          if (p != null) {
            p.isLikedByUser = backupMy.isLikedByUser;
            p.likesCount = backupMy.likesCount;
            p.likeCount = backupMy.likesCount;
          }
        }
        if (backupAll != null) {
          final p = allPosts.firstWhereOrNull((e) => e.id == postId);
          if (p != null) {
            p.isLikedByUser = backupAll.isLikedByUser;
            p.likesCount = backupAll.likesCount;
            p.likeCount = backupAll.likesCount;
          }
        }
        myPosts.refresh();
        allPosts.refresh();
        _showWarning('Failed to toggle like: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (backupMy != null) {
        final p = myPosts.firstWhereOrNull((e) => e.id == postId);
        if (p != null) {
          p.isLikedByUser = backupMy.isLikedByUser;
          p.likesCount = backupMy.likesCount;
          p.likeCount = backupMy.likesCount;
        }
      }
      if (backupAll != null) {
        final p = allPosts.firstWhereOrNull((e) => e.id == postId);
        if (p != null) {
          p.isLikedByUser = backupAll.isLikedByUser;
          p.likesCount = backupAll.likesCount;
          p.likeCount = backupAll.likesCount;
        }
      }
      myPosts.refresh();
      allPosts.refresh();
      print('Toggle like error: $e');
      _showWarning('Failed to toggle like. Please try again.');
    }
  }

  Future<void> toggleNotInterested(
    int postId,
    bool currentlyNotInterested,
  ) async {
    final postInAll = allPosts.firstWhereOrNull((p) => p.id == postId);
    final postInMy = myPosts.firstWhereOrNull((p) => p.id == postId);

    if (postInAll == null && postInMy == null) return;

    final oldNotInterestedAll = postInAll?.isNotInterestedByUser ?? false;
    final oldNotInterestedMy = postInMy?.isNotInterestedByUser ?? false;

    if (postInAll != null) {
      postInAll.isNotInterestedByUser = !currentlyNotInterested;
    }
    if (postInMy != null) {
      postInMy.isNotInterestedByUser = !currentlyNotInterested;
    }
    allPosts.refresh();
    myPosts.refresh();

    try {
      final apiUrl = Api.notInterestedPost(postId.toString());
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      final ok = response.statusCode == 200 || response.statusCode == 201;
      if (!ok) {
        if (postInAll != null) {
          postInAll.isNotInterestedByUser = oldNotInterestedAll;
        }
        if (postInMy != null) {
          postInMy.isNotInterestedByUser = oldNotInterestedMy;
        }
        allPosts.refresh();
        myPosts.refresh();
        _showWarning(
          'Failed to toggle not interested: ${response.reasonPhrase}',
        );
        return;
      }

      if (!currentlyNotInterested) {
        allPosts.removeWhere((p) => p.id == postId);
        myPosts.removeWhere((p) => p.id == postId);
        allPosts.refresh();
        myPosts.refresh();
      }
    } catch (e) {
      if (postInAll != null) {
        postInAll.isNotInterestedByUser = oldNotInterestedAll;
      }
      if (postInMy != null) {
        postInMy.isNotInterestedByUser = oldNotInterestedMy;
      }
      allPosts.refresh();
      myPosts.refresh();
      print('Toggle not interested error: $e');
      _showWarning('Failed to toggle not interested. Please try again.');
    }
  }

  Future<void> applyMyPostSort(String filter) async {
    selectedMyPostFilter.value = filter;
    if (myPosts.isEmpty) return Future.value();

    int _safeCompare(String a, String b) {
      final da = DateTime.tryParse(a);
      final db = DateTime.tryParse(b);
      if (da == null || db == null) return 0;
      return da.compareTo(db);
    }

    final list = [...myPosts];
    switch (filter) {
      case 'filter_new':
        list.sort((a, b) => _safeCompare(b.createdAt, a.createdAt));
        break;
      case 'filter_old':
        list.sort((a, b) => _safeCompare(a.createdAt, b.createdAt));
        break;
      case 'filter_all':
      default:
        break;
    }
    myPosts.value = list;
    return Future.value(); // Explicit return for Future<void>
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
      var uri = Uri.parse(Api.createPost);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await BaseClient.authHeaders());

      request.fields['title'] = 'My First Post';
      request.fields['content'] = statusController.text;

      for (var file in pickedMedia) {
        var multipartFile = await http.MultipartFile.fromPath('images', file.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("API Hit: $uri");
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAllPosts();
        fetchMyPosts();
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

  Future<void> updatePost(
      int postId,
      String title,
      String content,
      List<ImageData> existingImages,
      List<File> newImages,
      List<int> removedImageIds,
      ) async {
    if (title.isEmpty && content.isEmpty && existingImages.isEmpty && newImages.isEmpty) {
      _showWarning('Please provide some content or images to update.');
      return;
    }

    isLoading.value = true;
    try {
      var uri = Uri.parse(Api.updatePost(postId));
      var request = http.MultipartRequest('PATCH', uri);
      request.headers.addAll(await BaseClient.authHeaders());

      // Add title and content
      request.fields['title'] = title;
      request.fields['content'] = content;

      // Prepare images to upload
      List<File> imagesToUpload = [...newImages];

      // If adding new images, download and re-upload existing (kept) images to preserve them
      if (newImages.isNotEmpty && existingImages.isNotEmpty) {
        for (var existingImage in existingImages) {
          if (removedImageIds.contains(existingImage.id)) continue; // Skip removed images
          try {
            final imageResponse = await http.get(Uri.parse(existingImage.image));
            if (imageResponse.statusCode == 200) {
              final tempDir = await Directory.systemTemp.createTemp('post_update_');
              final fileName = existingImage.image.split('/').last;
              final tempFile = File('${tempDir.path}/$fileName');
              await tempFile.writeAsBytes(imageResponse.bodyBytes);
              imagesToUpload.add(tempFile);
              debugPrint('Downloaded and prepared existing image for re-upload: ${existingImage.image}');
            } else {
              debugPrint('Failed to download existing image: ${existingImage.image} (status: ${imageResponse.statusCode})');
            }
          } catch (e) {
            debugPrint('Error downloading existing image: ${existingImage.image} - $e');
          }
        }
      }

      // Add images to request (only if there are any to upload)
      if (imagesToUpload.isNotEmpty) {
        for (var file in imagesToUpload) {
          debugPrint('Uploading image: ${file.path}');
          var multipartFile = await http.MultipartFile.fromPath('images', file.path);
          request.files.add(multipartFile);
        }
      }

      // Send removed image IDs if any
      if (removedImageIds.isNotEmpty) {
        debugPrint('Removed image IDs: $removedImageIds');
        request.fields['removed_images'] = jsonEncode(removedImageIds);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("API Hit: $uri");
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final responseData = jsonDecode(response.body);

        // Find the post in local lists
        final postInAll = allPosts.firstWhereOrNull((p) => p.id == postId);
        final postInMy = myPosts.firstWhereOrNull((p) => p.id == postId);

        // Update title, content, tags
        if (postInAll != null) {
          postInAll.title = responseData['title'] ?? postInAll.title;
          postInAll.content = responseData['content'] ?? postInAll.content;
          postInAll.tags = responseData['tags'] ?? postInAll.tags;
        }
        if (postInMy != null) {
          postInMy.title = responseData['title'] ?? postInMy.title;
          postInMy.content = responseData['content'] ?? postInMy.content;
          postInMy.tags = responseData['tags'] ?? postInMy.tags;
        }

        // Update images from server response
        if (responseData['images'] != null && (responseData['images'] as List).isNotEmpty) {
          final imageList = (responseData['images'] as List)
              .where((imageData) => imageData != null && imageData is Map<String, dynamic>)
              .map((imageData) => ImageData.fromJson(imageData as Map<String, dynamic>))
              .toList();
          if (postInAll != null) {
            postInAll.images = imageList;
            debugPrint('Updated images for postInAll: ${imageList.map((img) => img.image).toList()}');
          }
          if (postInMy != null) {
            postInMy.images = imageList;
            debugPrint('Updated images for postInMy: ${imageList.map((img) => img.image).toList()}');
          }
        }

        // Refresh posts from server to sync any additional data
        await fetchMyPosts();
        allPosts.refresh();
        myPosts.refresh();
        Get.snackbar('Success', 'Post updated successfully!');
        Get.back();
        pickedMedia.clear();
      } else {
        _showWarning('Failed to update post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Update post error: $e');
      _showWarning('Failed to update post. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> toggleLike(int postId, bool currentlyLiked) async {
    final post = myPosts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    final oldLiked = post.isLikedByUser;
    final oldLikes = post.likesCount;
    post.isLikedByUser = !currentlyLiked;
    post.likesCount += currentlyLiked ? -1 : 1;
    post.likeCount = post.likesCount;
    myPosts.refresh();

    try {
      final apiUrl = Api.likePost(postId.toString());
      final response = await BaseClient.postRequest(
        api: apiUrl,
        body: jsonEncode({}),
        headers: BaseClient.authHeaders(),
      );

      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        post.isLikedByUser = oldLiked;
        post.likesCount = oldLikes;
        post.likeCount = oldLikes;
        myPosts.refresh();
        _showWarning('Failed to toggle like: ${response.reasonPhrase}');
      }
    } catch (e) {
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
        final oldLiked = comment.isLikedByUser.value;
        final oldLikes = comment.likesCount.value;
        comment.isLikedByUser.value = !currentlyLiked;
        comment.likesCount.value += currentlyLiked ? -1 : 1;

        final post =
            allPosts.firstWhereOrNull(
              (p) => p.comments.any(
                (c) =>
                    c.id == commentId ||
                    c.replies.any((r) => r.id == commentId),
              ),
            ) ??
            myPosts.firstWhereOrNull(
              (p) => p.comments.any(
                (c) =>
                    c.id == commentId ||
                    c.replies.any((r) => r.id == commentId),
              ),
            );
        if (post != null) {
          allPosts.refresh();
          myPosts.refresh();
        }

        final apiUrl = Api.likeComment(commentId.toString());
        final response = await BaseClient.postRequest(
          api: apiUrl,
          body: jsonEncode({}),
          headers: BaseClient.authHeaders(),
        );

        if (!(response.statusCode == 200 || response.statusCode == 201)) {
          comment.isLikedByUser.value = oldLiked;
          comment.likesCount.value = oldLikes;
          allPosts.refresh();
          myPosts.refresh();
          _showWarning('Failed to toggle like: ${response.reasonPhrase}');
        }
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

    final post =
        allPosts.firstWhereOrNull((p) => p.id == postId) ??
        myPosts.firstWhereOrNull((p) => p.id == postId);
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
        allPosts.refresh();
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

    bool isTopLevelComment = parentComment.parent == null;

    if (!isTopLevelComment && parentComment.replies.isNotEmpty) {
      _showWarning('Cannot add reply. Maximum reply depth reached.');
      return;
    }

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
        final post =
            allPosts.firstWhereOrNull(
              (p) => p.comments.any(
                (c) =>
                    c.id == commentId ||
                    c.replies.any((r) => r.id == commentId),
              ),
            ) ??
            myPosts.firstWhereOrNull(
              (p) => p.comments.any(
                (c) =>
                    c.id == commentId ||
                    c.replies.any((r) => r.id == commentId),
              ),
            );
        if (post != null) {
          allPosts.refresh();
          myPosts.refresh();
        }
        if (currentComment.value != null &&
            currentComment.value!.id == commentId) {
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
    for (final post in [...allPosts, ...myPosts]) {
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
