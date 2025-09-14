import 'dart:convert';
import 'dart:developer' as developer;

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
      final roomId =
          result['id'] as int; // Assuming API returns { "id": room_id }
      currentRoomId.value = roomId;
      developer.log(
        'Chat room created with ID: $roomId',
        name: 'MessageController',
      );
      connectWebSocket();
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
    String? token = await BaseClient.getAccessToken();
    if (token.isNull) {
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
      developer.log(
        'WebSocket connected successfully',
        name: 'MessageController',
      );

      _channel!.stream.listen(
        (data) {
          developer.log(
            'Received WebSocket message: $data',
            name: 'MessageController',
          );
          final message = jsonDecode(data) as Map<String, dynamic>;
          if (message['type'] == 'room_notification') {
            messages.add(message['message']);
            developer.log(
              'Room notification received: room_id=${message['message']['chat_room']}, content=${message['message']['content']}',
              name: 'MessageController',
            );
          } else if (message['type'] == 'user_status_update') {
            final userId = message['user_id'] as int;
            final isOnline = message['is_online'] as bool;
            final userIndex = activeUsers.indexWhere(
              (user) => user['user']['id'] == userId,
            );
            if (userIndex != -1) {
              activeUsers[userIndex]['is_online'] = isOnline;
              activeUsers[userIndex]['user']['is_online'] = isOnline;
              activeUsers.refresh();
              developer.log(
                'User status updated: user_id=$userId, is_online=$isOnline',
                name: 'MessageController',
              );
            } else {
              developer.log(
                'User ID $userId not found in active users',
                name: 'MessageController',
              );
            }
          } else {
            developer.log(
              'Unknown message type: ${message['type']}',
              name: 'MessageController',
            );
          }
        },
        onError: (error) {
          developer.log(
            'WebSocket error: $error',
            name: 'MessageController',
            error: error,
          );
          isWebSocketConnected.value = false;
          kSnackBar(
            title: 'Warning',
            message: 'WebSocket error: $error',
            bgColor: AppColors.snackBarWarning,
          );
        },
        onDone: () {
          developer.log(
            'WebSocket connection closed',
            name: 'MessageController',
          );
          isWebSocketConnected.value = false;
          _channel = null;
        },
      );
    } catch (e) {
      developer.log(
        'Failed to connect to WebSocket: $e',
        name: 'MessageController',
        error: e,
      );
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
      developer.log(
        'Cannot send message: WebSocket is null or roomId is 0',
        name: 'MessageController',
      );
      kSnackBar(
        title: 'Error',
        message:
            'Cannot send message: No active chat room or WebSocket connection',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }
    final messageData = {
      'type': 'send_message',
      'room_id': currentRoomId.value,
      'content': content,
      'message_type': messageType,
      'file': file,
    };
    developer.log('Sending message: $messageData', name: 'MessageController');
    _channel!.sink.add(jsonEncode(messageData));
  }
}
