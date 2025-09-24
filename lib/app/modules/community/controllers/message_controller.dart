import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class MessageController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxList<Map<String, dynamic>> activeUsers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> allChatRooms = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxInt currentRoomId = 0.obs;
  WebSocketChannel? _channel;
  RxBool isWebSocketConnected = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxBool isLoadingMoreMessages = false.obs; // Track pagination loading
  RxString nextPageUrl = RxString(''); // Initialize as empty string
  RxBool hasMoreMessages = true.obs; // Track if more messages are available
  final RxBool shouldScrollToBottom = false.obs; // Trigger scrolling

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchActiveUsers();
    fetchChatRooms();
    connectWebSocket();
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

  Future<void> fetchChatRooms() async {
    try {
      developer.log('Fetching chat rooms...', name: 'MessageController');
      final response = await BaseClient.getRequest(
        api: Api.getChatRooms, // Assuming Api.getChatRooms is defined in api.dart; add if needed (e.g., static String getChatRooms = '/chat/rooms/';)
        headers: BaseClient.authHeaders(),
      );
      final List result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getChatRooms,
          headers: BaseClient.authHeaders(),
        ),
      );
      final int? currentUserId = getCurrentUserId();
      if (currentUserId == null) {
        developer.log('Current user ID not found', name: 'MessageController');
        return;
      }
      // Filter rooms where current user is a participant
      allChatRooms.value = result
          .where((room) {
        if (room is! Map) return false;
        final List participants = room['participants'] as List? ?? [];
        return participants.any((p) => p is Map && p['id'] is int && p['id'] == currentUserId);
      })
          .map((room) => Map<String, dynamic>.from(room as Map))
          .toList();
      developer.log(
        'Filtered chat rooms fetched: ${allChatRooms.length} rooms',
        name: 'MessageController',
      );
    } catch (e) {
      developer.log(
        'Failed to fetch chat rooms: $e',
        name: 'MessageController',
        error: e,
      );
      allChatRooms.value = [];
    }
  }

  Future<void> fetchChatHistory(int roomId, {bool isLoadMore = false}) async {
    if (isLoadMore && (!hasMoreMessages.value || isLoadingMoreMessages.value)) {
      developer.log('No more messages or already loading', name: 'MessageController');
      return;
    }

    try {
      if (isLoadMore) {
        isLoadingMoreMessages.value = true;
      } else {
        isLoadingMessages.value = true;
      }
      developer.log('Fetching chat history for roomId: $roomId, isLoadMore: $isLoadMore', name: 'MessageController');
      final response = await BaseClient.getRequest(
        api: isLoadMore ? nextPageUrl.value : Api.getMessages(roomId),
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: isLoadMore ? nextPageUrl.value : Api.getMessages(roomId),
          headers: BaseClient.authHeaders(),
        ),
      );
      developer.log('API response for chat history: $result', name: 'MessageController');
      final List messagesList = result['results'] as List;
      nextPageUrl.value = result['next'] as String? ?? '';
      hasMoreMessages.value = result['next'] != null;

      final newMessages = List<Map<String, dynamic>>.from(messagesList);
      if (isLoadMore) {
        // Store current scroll extent for adjustment
        double? previousExtent;
        if (Get.isRegistered<ScrollController>()) {
          final scrollController = Get.find<ScrollController>();
          if (scrollController.hasClients) {
            previousExtent = scrollController.position.maxScrollExtent;
          }
        }
        messages.addAll(newMessages);
        messages.refresh();
        // Adjust scroll position
        if (previousExtent != null && Get.isRegistered<ScrollController>()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final scrollController = Get.find<ScrollController>();
            if (scrollController.hasClients) {
              final newExtent = scrollController.position.maxScrollExtent;
              final offsetDifference = newExtent - previousExtent!;
              scrollController.jumpTo(scrollController.offset + offsetDifference);
              developer.log('Adjusted scroll position by $offsetDifference, new offset: ${scrollController.offset}', name: 'MessageController');
            }
          });
        }
      } else {
        messages.assignAll(newMessages);
      }
      developer.log('Fetched ${newMessages.length} messages for roomId: $roomId, next: ${nextPageUrl.value}', name: 'MessageController');
      if (!isLoadMore) {
        shouldScrollToBottom.value = true; // Scroll to bottom only for initial load
      }
    } catch (e) {
      developer.log('Failed to fetch chat history: $e', name: 'MessageController', error: e);
      kSnackBar(
        title: 'Error',
        message: 'Failed to fetch chat history: $e',
        bgColor: AppColors.snackBarWarning,
      );
      if (!isLoadMore) {
        messages.clear();
      }
    } finally {
      isLoadingMessages.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  Future<void> fetchMoreMessages() async {
    await fetchChatHistory(currentRoomId.value, isLoadMore: true);
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

      // Refresh chat rooms after creating a new one
      await fetchChatRooms();
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
    final wsBaseUrl = Api.wsBaseUrl;
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
                messages.insert(0, newMessage);
                messages.refresh();
                if (newMessage['chat_room'] == currentRoomId.value) {
                  shouldScrollToBottom.value = true;
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
        'id': getCurrentUserId(),
      },
      'created_at': DateTime.now().toIso8601String(),
      'file': file,
      'image': null,
    };

    messages.insert(0, localMessage);
    messages.refresh();
    shouldScrollToBottom.value = true;

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


  int? getCurrentUserId() {
    final DashboardController dashboardController = Get.find<DashboardController>();
    final userId = dashboardController.userId.value;
    print('---------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CURRENT USER ID $userId');
    return userId;

  }

  Future<void> markMessagesAsRead(int roomId) async {
    try {
      developer.log('Marking messages as read for roomId: $roomId', name: 'MessageController');
      final response = await BaseClient.postRequest(
        api: Api.setChatRoomRead(roomId),
        headers: BaseClient.authHeaders(),
        body: '',
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.setChatRoomRead(roomId),
          headers: BaseClient.authHeaders(),
          body: '',
        ),
      );
      developer.log('Mark messages as read response: $result', name: 'MessageController');

      // Update the unread_count in allChatRooms
      final roomIndex = allChatRooms.indexWhere((room) => room['id'] == roomId);
      if (roomIndex != -1) {
        allChatRooms[roomIndex]['unread_count'] = 0;
        allChatRooms.refresh();
      }

      // Refresh chat rooms to get the latest unread counts
      await fetchChatRooms();
    } catch (e) {
      developer.log('Error marking messages as read: $e', name: 'MessageController', error: e);
      kSnackBar(
        title: 'Error',
        message: 'Failed to mark messages as read: $e',
        bgColor: AppColors.snackBarWarning,
      );
    }
  }
}