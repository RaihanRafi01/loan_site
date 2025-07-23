import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? prefixSvgPath;
  final String? suffixSvgPath;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isNoIcon;
  final int maxLine;
  final double radius;
  final Color bgClr;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.prefixSvgPath,
    this.suffixSvgPath,
    this.onSuffixTap,
    this.obscureText = false,
    this.isNoIcon = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLine = 1,
    this.radius = 100,
    this.bgClr = AppColors.textInputField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        maxLines: maxLine,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: h4.copyWith(color: AppColors.blurtext2, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(
            vertical: maxLine > 1 ? 12 : 8, // Adjust padding for multiline
            horizontal: 10,
          ),
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
            onTap: onSuffixTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 26, left: 5),
              child: SvgPicture.asset(
                suffixSvgPath!,
              ),
            ),
          )
              : null,
          filled: true,
          fillColor: bgClr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: AppColors.appColor),
          ),
        ),
      ),
    );
  }
}