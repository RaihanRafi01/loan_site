import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/auth/views/signUp_view.dart';
import '../appColors.dart';
import '../customFont.dart';
import 'customButton.dart';

class ChooseRolePopupWidget extends StatelessWidget {
  const ChooseRolePopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text in the card
            Text(
              'Choose your role first',
              style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Buttons in a column
            CustomButton(
              label: 'Private Lender',
              onPressed: () {
                Get.back(); // Close dialog
                Get.to(() => const SignUpScreen(role: 'private_lender'));
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Borrower',
              onPressed: () {
                Get.back(); // Close dialog
                Get.to(() => const SignUpScreen(role: 'borrower'));
              },
            ),
          ],
        ),
      ),
    );
  }
}