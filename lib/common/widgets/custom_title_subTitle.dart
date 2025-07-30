import 'package:flutter/material.dart';

import '../appColors.dart';
import '../customFont.dart';

class TitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final List<TextSpan>? subtitleSpans;

  const TitleSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleStyle,
    this.subtitleSpans,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [AppColors.textColor3, AppColors.textColor4],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            title,
            style: h3.copyWith(fontSize: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        if (subtitleSpans != null)
          RichText(
            text: TextSpan(
              style: h4.copyWith(fontSize: 18, color: AppColors.textColor2),
              children: subtitleSpans,
            ),
          )
        else
          Text(
            subtitle,
            style:
            subtitleStyle ??
                h4.copyWith(fontSize: 18, color: AppColors.textColor2),
          ),
      ],
    );
  }
}