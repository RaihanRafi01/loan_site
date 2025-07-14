import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String prefixSvgPath; // SVG asset path for prefix
  final String? suffixSvgPath; // Optional SVG asset path for suffix (e.g., visibility toggle)
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixSvgPath,
    this.suffixSvgPath,
    this.obscureText = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // Initialize with the provided obscureText value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.labelText,
          hintStyle: h4.copyWith(color: AppColors.blurtext2, fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 26, right: 5),
            child: SvgPicture.asset(
              widget.prefixSvgPath,
            ),
          ),
          suffixIcon: widget.suffixSvgPath != null
              ? GestureDetector(
            onTap: () {
              setState(() {
                _isObscure = !_isObscure; // Toggle visibility
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 26, left: 5),
              child: SvgPicture.asset(
                _isObscure
                    ? widget.suffixSvgPath! // Show "visible" icon
                    : 'assets/svg/visibility_off.svg', // Assume this is the hidden icon path
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