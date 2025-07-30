import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/views/set_milestone_view.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customButton.dart';

// Model to represent a lender
class Lender {
  final String imageUrl;
  final String name;
  RxBool isChecked;

  Lender({required this.imageUrl, required this.name, bool isChecked = false})
    : isChecked = isChecked.obs;
}

class SelectLenderController extends GetxController {
  // List of lenders with their checkbox states
  RxList<Lender> lenders = <Lender>[].obs;
  RxInt selectedIndex = (-1).obs; // Track the single selected lender
  var showConfirm = false.obs;
  void showConfirmationAndNavigate() {
    showConfirm.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showConfirm.value = false;
      Get.offAll(() => const SetMilestoneView());
    });
  }

  @override
  void onInit() {
    super.onInit();
    lenders.addAll([
      Lender(
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        name: 'Jack',
      ),
      Lender(
        imageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Flores',
      ),
      Lender(
        imageUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        name: 'Miles',
      ),
      Lender(
        imageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Arthur',
      ),
      Lender(
        imageUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        name: 'Esther',
      ),

    ]);
  }

  // Method to select a single lender
  void selectLender(int index) {
    if (selectedIndex.value != -1) {
      lenders[selectedIndex.value].isChecked.value = false;
    }
    lenders[index].isChecked.value = true;
    selectedIndex.value = index;
  }
}

class LenderHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RxBool isChecked;
  final ValueChanged<bool?> onCheckChanged;

  const LenderHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isChecked,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                backgroundColor: imageUrl.isEmpty
                    ? AppColors.appColor2.withOpacity(0.2)
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32, color: AppColors.appColor2)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ],
          ),
          Obx(
            () => Checkbox(
              value: isChecked.value,
              onChanged: onCheckChanged,
              activeColor: Colors.blue, // Checkbox color
              checkColor: Colors.white, // Checkmark color
            ),
          ),
        ],
      ),
    );
  }
}

class SelectLenderView extends GetView<SelectLenderController> {
  const SelectLenderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SelectLenderController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        title: Text(
          'Select Your Lender',
          style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.appBc,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(
              () => Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Search Bar
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.cardSky,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search,
                                      color: Colors.grey[600], size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search here',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                                  () => Column(
                                children: List.generate(
                                  controller.lenders.length,
                                      (index) => LenderHeaderWidget(
                                    imageUrl: controller.lenders[index].imageUrl,
                                    title: controller.lenders[index].name,
                                    isChecked: controller.lenders[index].isChecked,
                                    onCheckChanged: (value) {
                                      if (value == true) {
                                        controller.selectLender(index);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80), // Space for the button
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Fixed Confirm Button at the bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: CustomButton(
                  label: 'Confirm',
                  onPressed: () {
                    controller.showConfirmationAndNavigate();
                  },
                ),
              ),
              // Confirmation dialog
              if (controller.showConfirm.value)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      controller.showConfirm.value = false; // Dismiss card on outside tap
                    },
                    child: Stack(
                      children: [
                        // Blurred background
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                          ),
                        ),
                        // Centered card
                        Center(
                          child: GestureDetector(
                            onTap: () {}, // Prevents taps on the card from dismissing it
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              child: Container(
                                width: 300,
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/auth/tic_icon.svg',
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Your project has been created successfully!',
                                      style: h4.copyWith(
                                        fontSize: 20,
                                        color: AppColors.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
