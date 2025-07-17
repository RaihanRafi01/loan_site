import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContractorController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController = PageController(initialPage: 0);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final loanAmountController = TextEditingController();
  final loanTermController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    loanAmountController.dispose();
    loanTermController.dispose();
    super.onClose();
  }
}