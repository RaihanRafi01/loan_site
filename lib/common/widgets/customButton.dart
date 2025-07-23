import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isWhite;
  final List<Color> bgClr;
  final Color txtClr;
  final String? svgPath;
  final String? svgPath2;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double radius;
  final double fontSize;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isWhite = false,
    this.bgClr = const [AppColors.appColor, AppColors.appColor2],
    this.txtClr = Colors.white,
    this.svgPath,
    this.svgPath2,
    this.borderColor,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 48,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isWhite ? [Colors.white, Colors.white] : bgClr,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : isWhite
              ? Border.all(color: txtClr, width: 1)
              : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgPath != null) ...[
              SvgPicture.asset(
                svgPath!,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: h3.copyWith(fontSize: fontSize, color: isWhite ? AppColors.textColor3 : txtClr),
            ),
            if (svgPath2 != null) ...[
              const SizedBox(width: 4),
              SvgPicture.asset(
                svgPath2!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}