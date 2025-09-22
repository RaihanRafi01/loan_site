import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;

  Future<void> toggleListening(TextEditingController controller, {String localeId = 'en_US'}) async {
    if (!isListening.value) {
      // Check microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        isListening.value = false;
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (error) {
          isListening.value = false;
        },
      );

      if (available) {
        isListening.value = true;
        _speech.listen(
          onResult: (result) {
            controller.text = result.recognizedWords; // Real-time update
            if (result.finalResult) {
              isListening.value = false;
            }
          },
          localeId: localeId,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
        );
      } else {
        isListening.value = false;
      }
    } else {
      isListening.value = false;
      _speech.stop();
    }
  }

  void dispose() {
    _speech.stop();
  }
}