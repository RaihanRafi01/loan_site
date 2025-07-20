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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonHideUnderline(
        child: Builder(
          builder: (context) {
            return DropdownButtonFormField<String>(
              icon: SvgPicture.asset('assets/images/contractor/arrow_down.svg'),
              value: value,
              onChanged: onChanged,
              dropdownColor: Colors.white, // Matches HistoryView's light mode dropdown
              alignment: AlignmentDirectional.centerStart, // Opens from right
              borderRadius: BorderRadius.circular(12), // Rounded dropdown menu
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    width: 150, // Reduced width for dropdown menu
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item,
                      style: h4.copyWith(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400, // Reduced font weight
                      ),
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: h4.copyWith(color: AppColors.blurtext2, fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
