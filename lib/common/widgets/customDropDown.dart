import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../appColors.dart';
import '../customFont.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width to constrain the dropdown menu
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonHideUnderline(
        child: Builder(
          builder: (context) {
            return DropdownButtonFormField<String>(
              icon: SvgPicture.asset('assets/images/contractor/arrow_down.svg'),
              value: value,
              onChanged: onChanged,
              dropdownColor: Colors.white,
              // Constrain the dropdown menu width
              menuMaxHeight: 300, // Optional: Limit menu height to avoid vertical overflow
              isExpanded: true, // Makes the dropdown take full available width
              alignment: AlignmentDirectional.center, // Center the menu to avoid right overflow
              borderRadius: BorderRadius.circular(12),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.8, // Limit item width to 80% of screen
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item,
                      style: h4.copyWith(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis, // Truncate long text
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: h4.copyWith(color: AppColors.blurtext2, fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Reduced padding
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
            );
          },
        ),
      ),
    );
  }
}