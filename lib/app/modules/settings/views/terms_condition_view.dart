import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class TermsConditionView extends GetView {
  const TermsConditionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBc,
        elevation: 0,
        title: Text(
          'Terms & Conditions',
          style: h2.copyWith(color: AppColors.textColor, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'last updeat 4 october 2024',
              style: h2.copyWith(fontSize: 20,color: AppColors.appColor2),
            ),
            SizedBox(height: 6),
            Text(
              'Welcome to  accessing and using our platform, you agree to be bound by these Terms & Conditions. These terms are designed to protect both you as a user and  as a service provider. If you disagree with any part of these terms, we kindly ask that you refrain from using the platform.',
              style: h4.copyWith(fontSize: 14,color: AppColors.textColor),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '1. Acceptance of terms',
                style: h2.copyWith(fontSize: 20,color: AppColors.appColor2),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'By using the LangSwap platform, you agree to abide by these Terms & Conditions. If you do not agree to these terms, please refrain from using the platform.',
              style: h4.copyWith(fontSize: 14,color: AppColors.textColor),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '2. User Responsibilities',
                style: h2.copyWith(fontSize: 20,color: AppColors.appColor2),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Our responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree not to use LangSwap for any illegal or unauthorized purposes',
              style: h4.copyWith(fontSize: 14,color: AppColors.textColor),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '3. Privacy Policy',
                style: h2.copyWith(fontSize: 20,color: AppColors.appColor2),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Our privacy is important to us. Our Privacy Policy outlines how we collect, use, and protect your personal data. By using LangSwap, you consent to the collection and use of your data as described in our Privacy Policy.',
              style: h4.copyWith(fontSize: 14,color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
