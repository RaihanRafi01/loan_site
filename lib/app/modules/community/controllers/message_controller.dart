import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class MessageController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxList<Map<String, dynamic>> activeUsers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxInt currentRoomId = 0.obs;
  WebSocketChannel? _channel;
  RxBool isWebSocketConnected = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxBool isLoadingMoreMessages = false.obs; // Track pagination loading
  RxString nextPageUrl = RxString(''); // Initialize as empty string
  final RxBool shouldScrollToBottom = false.obs; // Trigger scrolling

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchActiveUsers();
  }

  @override
  void onClose() {
    developer.log('Closing WebSocket connection', name: 'MessageController');
    _channel?.sink.close();
    isWebSocketConnected.value = false;
    super.onClose();
  }

  Future<void> fetchActiveUsers() async {
    try {
      developer.log('Fetching active users...', name: 'MessageController');
      final response = await BaseClient.getRequest(
        api: Api.getActiveUsers,
        headers: BaseClient.authHeaders(),
      );
      final List result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getActiveUsers,
          headers: BaseClient.authHeaders(),
        ),
      );
      activeUsers.value = List<Map<String, dynamic>>.from(result);
      developer.log(
        'Active users fetched: ${activeUsers.length} users',
        name: 'MessageController',
      );
    } catch (e) {
      developer.log(
        'Failed to fetch active users: $e',
        name: 'MessageController',
        error: e,
      );
      activeUsers.value = [];
    }
  }

  Future<void> fetchChatHistory(int roomId) async {
    try {
      isLoadingMessages.value = true;
      developer.log('Fetching chat history for roomId: $roomId', name: 'MessageController');
      final response = await BaseClient.getRequest(
        api: Api.getMessages(roomId),
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getMessages(roomId),
          headers: BaseClient.authHeaders(),
        ),
      );
      developer.log('API response for chat history: $result', name: 'MessageController');
      final List messagesList = result['results'] as List;
      nextPageUrl.value = result['next'] as String? ?? ''; // Use empty string if null
      // Sort messages by created_at in descending order (newest first)
      messages.value = List<Map<String, dynamic>>.from(messagesList)
        ..sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      developer.log('Fetched ${messages.length} messages for roomId: $roomId, next: ${nextPageUrl.value}', name: 'MessageController');
      if (messages.isNotEmpty) {
        developer.log('First message: ${messages.first['created_at']}, Last message: ${messages.last['created_at']}', name: 'MessageController');
      }
      shouldScrollToBottom.value = true; // Trigger scroll after fetch
    } catch (e) {
      developer.log('Failed to fetch chat history: $e', name: 'MessageController', error: e);
      kSnackBar(
        title: 'Error',
        message: 'Failed to fetch chat history: $e',
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoadingMessages.value = false;
    }
  }

  Future<void> fetchMoreMessages() async {
    if (nextPageUrl.value.isEmpty || isLoadingMoreMessages.value) {
      developer.log('No more messages to fetch or already loading, nextPageUrl: ${nextPageUrl.value}', name: 'MessageController');
      return;
    }
    try {
      isLoadingMoreMessages.value = true;
      developer.log('Fetching more messages from: ${nextPageUrl.value}', name: 'MessageController');
      // Extract path if BaseClient prepends a base URL
      String apiPath = nextPageUrl.value;
      /*if (nextPageUrl.value.startsWith(Api.baseUrl)) {
        apiPath = nextPageUrl.value.substring(Api.baseUrl.length);
      }*/
      final response = await BaseClient.getRequest(
        api: apiPath,
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: apiPath,
          headers: BaseClient.authHeaders(),
        ),
      );
      developer.log('API response for more messages: $result', name: 'MessageController');
      final List newMessages = result['results'] as List;
      nextPageUrl.value = result['next'] as String? ?? ''; // Use empty string if null
      // Store current scroll offset
      double? currentOffset;
      if (Get.isRegistered<ScrollController>()) {
        final scrollController = Get.find<ScrollController>();
        if (scrollController.hasClients) {
          currentOffset = scrollController.offset;
        }
      }
      // Append new messages, maintaining descending order
      final newMessagesSorted = List<Map<String, dynamic>>.from(newMessages)
        ..sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      messages.addAll(newMessagesSorted);
      messages.refresh();
      developer.log('Fetched ${newMessages.length} more messages, next: ${nextPageUrl.value}', name: 'MessageController');
      if (messages.isNotEmpty) {
        developer.log('First message: ${messages.first['created_at']}, Last message: ${messages.last['created_at']}', name: 'MessageController');
      }
      // Adjust scroll position to maintain view
      if (currentOffset != null && Get.isRegistered<ScrollController>()) {
        final scrollController = Get.find<ScrollController>();
        if (scrollController.hasClients) {
          // Estimate additional height (adjust 50 based on your message widget height)
          final additionalHeight = newMessages.length * 50;
          scrollController.jumpTo(currentOffset + additionalHeight);
          developer.log('Adjusted scroll position: ${currentOffset + additionalHeight}', name: 'MessageController');
        }
      }
    } catch (e) {
      developer.log('Failed to fetch more messages: $e', name: 'MessageController', error: e);
      kSnackBar(
        title: 'Error',
        message: 'Failed to load more messages: $e',
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoadingMoreMessages.value = false;
    }
  }

  Future<int?> createChatRoom(int recipientId) async {
    try {
      developer.log(
        'Creating chat room for recipient ID: $recipientId',
        name: 'MessageController',
      );
      final response = await BaseClient.postRequest(
        api: Api.createChatRoom,
        headers: BaseClient.authHeaders(),
        body: jsonEncode({'recipient_id': recipientId}),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.createChatRoom,
          headers: BaseClient.authHeaders(),
          body: jsonEncode({'recipient_id': recipientId}),
        ),
      );
      final roomId = result['id'] as int;
      currentRoomId.value = roomId;
      developer.log(
        'Chat room created with ID: $roomId',
        name: 'MessageController',
      );
      await connectWebSocket();
      return roomId;
    } catch (e) {
      developer.log(
        'Failed to create chat room: $e',
        name: 'MessageController',
        error: e,
      );
      kSnackBar(
        title: 'Warning',
        message: 'Failed to create chat room: $e',
        bgColor: AppColors.snackBarWarning,
      );
      return null;
    }
  }

  Future<void> connectWebSocket() async {
    const wsBaseUrl = 'ws://10.10.13.73:7000';
    final token = await BaseClient.getAccessToken();
    if (token == null || token.isEmpty) {
      developer.log(
        'No access token available for WebSocket',
        name: 'MessageController',
      );
      kSnackBar(
        title: 'Error',
        message: 'No access token available',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    developer.log(
      'Connecting to WebSocket with token: $token',
      name: 'MessageController',
    );
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$wsBaseUrl/ws/chat/?token=$token'),
      );
      isWebSocketConnected.value = true;
      developer.log('WebSocket connected successfully', name: 'MessageController');

      _channel!.stream.listen(
            (data) {
          developer.log('Received WebSocket raw data: $data', name: 'MessageController');
          try {
            final message = jsonDecode(data) as Map<String, dynamic>;
            developer.log('Parsed WebSocket message: $message', name: 'MessageController');

            if (message['type'] == 'room_notification') {
              final newMessage = message['message'] as Map<String, dynamic>;

              final isDuplicate = messages.any((msg) =>
              msg['chat_room'] == newMessage['chat_room'] &&
                  msg['content'] == newMessage['content'] &&
                  (DateTime.parse(msg['created_at'])
                      .difference(DateTime.parse(newMessage['created_at']))
                      .inSeconds
                      .abs() <
                      5));

              if (!isDuplicate) {
                // Insert new message at the start to maintain descending order
                messages.insert(0, newMessage);
                messages.refresh();
                if (newMessage['chat_room'] == currentRoomId.value) {
                  shouldScrollToBottom.value = true; // Trigger scroll for new message
                }
                developer.log(
                  'Room notification received: room_id=${newMessage['chat_room']}, '
                      'content=${newMessage['content']}, type=${newMessage['message_type']}, '
                      'image=${newMessage['image'] ?? 'none'}, file=${newMessage['file'] ?? 'none'}',
                  name: 'MessageController',
                );
              } else {
                developer.log('Duplicate message ignored: ${newMessage['content']}',
                    name: 'MessageController');
              }
            } else if (message['type'] == 'user_status_update') {
              final userId = message['user_id'] as int;
              final isOnline = message['is_online'] as bool;
              final userIndex =
              activeUsers.indexWhere((user) => user['user']['id'] == userId);
              if (userIndex != -1) {
                activeUsers[userIndex]['is_online'] = isOnline;
                activeUsers[userIndex]['user']['is_online'] = isOnline;
                activeUsers.refresh();
              }
            } else {
              developer.log('Unknown message type: ${message['type']}',
                  name: 'MessageController');
            }
          } catch (e) {
            developer.log('Failed to parse WebSocket message: $e',
                name: 'MessageController', error: e);
          }
        },
        onError: (error) {
          developer.log('WebSocket error: $error', name: 'MessageController', error: error);
          isWebSocketConnected.value = false;
          kSnackBar(
            title: 'Warning',
            message: 'WebSocket error: $error',
            bgColor: AppColors.snackBarWarning,
          );
        },
        onDone: () {
          developer.log('WebSocket connection closed', name: 'MessageController');
          isWebSocketConnected.value = false;
          _channel = null;
        },
      );
    } catch (e) {
      developer.log('Failed to connect to WebSocket: $e',
          name: 'MessageController', error: e);
      isWebSocketConnected.value = false;
      kSnackBar(
        title: 'Error',
        message: 'Failed to connect to WebSocket: $e',
        bgColor: AppColors.snackBarWarning,
      );
    }
  }

  void sendMessage(String content, String messageType, {String file = ''}) {
    if (_channel == null || currentRoomId.value == 0) {
      developer.log('Cannot send message: WebSocket is null or roomId is 0',
          name: 'MessageController');
      kSnackBar(
        title: 'Error',
        message: 'Cannot send message: No active chat room or WebSocket connection',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    final localMessage = {
      'chat_room': currentRoomId.value,
      'content': content,
      'message_type': messageType,
      'sender': {
        'id': _getCurrentUserId(),
      },
      'created_at': DateTime.now().toIso8601String(),
      'file': file,
      'image': null,
    };

    // Insert at the start to maintain descending order
    messages.insert(0, localMessage);
    messages.refresh();
    shouldScrollToBottom.value = true; // Trigger scroll after sending

    final messageData = {
      'type': 'send_message',
      'room_id': currentRoomId.value,
      'content': content,
      'message_type': messageType,
      'file': file,
    };
    developer.log(' ❄️❄️❄️ Sending message: $messageData', name: 'MessageController');
    _channel!.sink.add(jsonEncode(messageData));
  }

  int _getCurrentUserId() {
    return 6; // Placeholder
  }
}