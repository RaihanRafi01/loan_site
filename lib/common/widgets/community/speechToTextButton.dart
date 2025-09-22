import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';
import '../../../app/core/services/stt_service.dart';

class SpeechToTextButton extends StatelessWidget {
  final SpeechToTextService speechService;
  final TextEditingController controller;

  const SpeechToTextButton({
    super.key,
    required this.speechService,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => speechService.toggleListening(controller),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(speechService.isListening.value ? 8 : 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: !speechService.isListening.value ? AppColors.chatInput : Colors.white,
          boxShadow: !speechService.isListening.value
              ? [
            BoxShadow(
              color: AppColors.chatInput.withOpacity(0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ]
              : [],
        ),
        child: SvgPicture.asset('assets/images/home/mic_icon.svg',),
      ),
    ));
  }
}