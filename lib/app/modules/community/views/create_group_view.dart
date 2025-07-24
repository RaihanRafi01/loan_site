import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';

// Model to represent a user
class User {
  final String imageUrl;
  final String name;
  RxBool isChecked;

  User({
    required this.imageUrl,
    required this.name,
    bool isChecked = false,
  }) : isChecked = isChecked.obs;
}

class CreateGroupController extends GetxController {
  // List of users with their checkbox states
  RxList<User> users = <User>[].obs;

  // Initialize users (you can fetch this from an API or other source)
  @override
  void onInit() {
    super.onInit();
    users.addAll([
      User(
        imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        name: 'Jack',
      ),
      User(
        imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Flores',
      ),
      User(
        imageUrl:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        name: 'Miles',
      ),
      User(
        imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Arthur',
      ),
      User(
        imageUrl:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        name: 'Esther',
      ),
    ]);
  }

  // Method to toggle the checkbox state for a specific user
  void toggleCheck(int index) {
    users[index].isChecked.value = !users[index].isChecked.value;
  }
}

class GroupHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RxBool isChecked; // Observable bool for this specific user
  final VoidCallback onCheckTap;

  const GroupHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isChecked,
    required this.onCheckTap,
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
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                backgroundColor:
                imageUrl.isEmpty ? AppColors.appColor2.withOpacity(0.2) : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32, color: AppColors.appColor2)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: h2.copyWith(
                  fontSize: 20,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onCheckTap,
            child: Obx(() => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isChecked.value ? AppColors.appColor2 : AppColors.gray11,
                  width: 1,
                ),
                color: isChecked.value ? AppColors.appColor2 : Colors.transparent,
              ),
              child: isChecked.value
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
                  : null,
            )),
          ),
        ],
      ),
    );
  }
}

class CreateGroupView extends GetView<CreateGroupController> {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateGroupController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset('assets/images/community/arrow_left.svg'),
                  ),
                  Text(
                    'Add',
                    style: h2.copyWith(
                      fontSize: 24,
                      color: AppColors.appColor2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: List.generate(
                  controller.users.length,
                      (index) => GroupHeaderWidget(
                    imageUrl: controller.users[index].imageUrl,
                    title: controller.users[index].name,
                    isChecked: controller.users[index].isChecked,
                    onCheckTap: () => controller.toggleCheck(index),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}