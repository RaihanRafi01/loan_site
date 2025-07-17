import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? prefixSvgPath; // Optional SVG asset path for prefix
  final String? suffixSvgPath; // Optional SVG asset path for suffix
  final VoidCallback? onSuffixTap; // Callback for suffix icon tap
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isNoIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.prefixSvgPath,
    this.suffixSvgPath,
    this.onSuffixTap, // New callback parameter
    this.obscureText = false,
    this.isNoIcon = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: h4.copyWith(color: AppColors.blurtext2, fontSize: 16),
          prefixIcon: isNoIcon || prefixSvgPath == null
              ? null
              : Padding(
            padding: const EdgeInsets.only(left: 26, right: 5),
            child: SvgPicture.asset(
              prefixSvgPath!,
            ),
          ),
          suffixIcon: suffixSvgPath != null
              ? GestureDetector(
            onTap: onSuffixTap, // Use the provided callback
            child: Padding(
              padding: const EdgeInsets.only(right: 26, left: 5),
              child: SvgPicture.asset(
                suffixSvgPath!, // Always show the provided suffix icon
              ),
            ),
          )
              : null,
          filled: true,
          fillColor: AppColors.textInputField,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.appColor),
          ),
        ),
      ),
    );
  }
}