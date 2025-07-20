import 'package:flutter/material.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isWhite;
  final List<Color> bgClr;
  final Color txtClr;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isWhite = false,
    this.bgClr = const [AppColors.appColor, AppColors.appColor2],
    this.txtClr = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isWhite ? [Colors.white, Colors.white] : bgClr,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: isWhite ? Border.all(color: txtClr, width: 1) : null,
          borderRadius: BorderRadius.circular(48),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: h3.copyWith(fontSize: 20, color: isWhite ? AppColors.textColor3 : txtClr),
        ),
      ),
    );
  }
}