import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/appColors.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../project/controllers/project_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool isPlaceholder;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isPlaceholder = false,
  });

  ChatMessage copyWith({String? text, bool? isPlaceholder}) => ChatMessage(
    text: text ?? this.text,
    isUser: isUser,
    time: time,
    isPlaceholder: isPlaceholder ?? this.isPlaceholder,
  );
}

class ChatController extends GetxController {
  final textController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final isSending = false.obs;
  final isHistoryLoading = false.obs;
  final currentProject = Rxn<ProjectDetail>();
  final isContextLoaded = false.obs;

  bool _historyLoadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    _loadContextFromPrefs().then((_) {
      isContextLoaded.value = true;
      loadChatHistory();
    });
    // Listen for project changes to reload history
    ever(currentProject, (_) {
      if (isContextLoaded.value) {
        _historyLoadedOnce = false; // Allow reloading history
        loadChatHistory();
      }
    });
  }

  Future<void> _loadContextFromPrefs() async {
    try {
      final project = await ProjectPrefs.getCurrentProject();
      currentProject.value = project;
    } catch (e) {
      debugPrint('Error loading project context: $e');
      Get.snackbar(
        'Error',
        'Failed to load project context: $e',
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
    }
  }

  Future<void> loadChatHistory() async {
    if (_historyLoadedOnce) return; // Avoid reloading on rebuilds
    try {
      isHistoryLoading.value = true;

      final resp = await BaseClient.getRequest(
        api: Api.chatHistory,
        headers: BaseClient.authHeaders(),
      );

      final data = await BaseClient.handleResponse(
        resp,
        retryRequest: () => BaseClient.getRequest(
          api: Api.chatHistory,
          headers: BaseClient.authHeaders(),
        ),
      );

      // Expecting a List like you showed
      final list = (data as List).cast<Map<String, dynamic>>();

      // Sort by created_at ASC so the oldest is first
      list.sort((a, b) {
        final da = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final db = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return da.compareTo(db);
      });

      // Map to bubbles: user question then AI answer
      final history = <ChatMessage>[];
      for (final item in list) {
        final created = DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();

        final q = (item['question'] as String?)?.trim();
        if (q != null && q.isNotEmpty) {
          history.add(ChatMessage(text: q, isUser: true, time: created));
        }

        final a = (item['answer'] as String?)?.trim();
        if (a != null && a.isNotEmpty) {
          // Tiny offset so AI bubble appears just after the question in time ordering
          history.add(ChatMessage(text: a, isUser: false, time: created.add(const Duration(milliseconds: 1))));
        }
      }

      // If there is history, use it; otherwise keep the warm-up greeting
      if (history.isNotEmpty) {
        messages.value = history;
      } else if (messages.isEmpty) {
        final pname = currentProject.value?.name.isNotEmpty == true
            ? '"${currentProject.value!.name}"'
            : 'your project';
        messages.add(ChatMessage(
          text: 'Hi! I’m your AI assistant for $pname. How can I help?',
          isUser: false,
          time: DateTime.now(),
        ));
      }

      _historyLoadedOnce = true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load chat history: $e',
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
    } finally {
      isHistoryLoading.value = false;
    }
  }

  Future<void> sendMessage({String? text}) async {
    final msg = (text ?? textController.text).trim();
    if (msg.isEmpty || isSending.value) return;

    messages.add(ChatMessage(text: msg, isUser: true, time: DateTime.now()));
    textController.clear();

    final placeholder = ChatMessage(
      text: 'Typing…',
      isUser: false,
      time: DateTime.now(),
      isPlaceholder: true,
    );
    messages.add(placeholder);

    try {
      isSending.value = true;

      // Build payload with full project context
      final payload = {
        "message": msg,
        "project_name": currentProject.value?.name ?? '',
        "current_milestone":
        currentProject.value?.milestones.firstWhereOrNull((m) => m.status != 'completed')?.name ?? 'General',
        "project_type": currentProject.value?.type ?? '',
        "project_progress": currentProject.value != null
            ? {
          "percentage": currentProject.value!.progress.percentage,
          "completed_phases": currentProject.value!.progress.completedPhases,
          "total_phases": currentProject.value!.progress.totalPhases,
        }
            : null,
      };

      final resp = await BaseClient.postRequest(
        api: Api.chatAssistant,
        body: jsonEncode(payload),
        headers: BaseClient.authHeaders(),
      );

      final data = await BaseClient.handleResponse(
        resp,
        retryRequest: () => BaseClient.postRequest(
          api: Api.chatAssistant,
          body: jsonEncode(payload),
          headers: BaseClient.authHeaders(),
        ),
      );

      final reply = (data is Map && data['message'] is String)
          ? data['message'] as String
          : 'Sorry, I could not parse a valid response.';

      final idx = messages.lastIndexWhere((m) => m.isPlaceholder);
      if (idx != -1) {
        messages[idx] = messages[idx].copyWith(text: reply, isPlaceholder: false);
      } else {
        messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      }
    } catch (e) {
      final idx = messages.lastIndexWhere((m) => m.isPlaceholder);
      if (idx != -1) messages.removeAt(idx);

      messages.add(ChatMessage(
        text: 'Failed to send. Please try again.',
        isUser: false,
        time: DateTime.now(),
      ));
      Get.snackbar(
        'Error',
        'Chat request failed: $e',
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
    } finally {
      isSending.value = false;
    }
  }

  // Method to reload context and history when project changes
  void refreshContext() {
    _historyLoadedOnce = false; // Allow reloading history
    _loadContextFromPrefs().then((_) => loadChatHistory());
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}