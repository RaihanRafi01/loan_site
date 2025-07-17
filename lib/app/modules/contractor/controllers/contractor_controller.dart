import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContractorController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final flooringTypeController = TextEditingController();
  final approxAreaController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  // Observable variables for time and date
  var selectedTime = ''.obs;
  var selectedDate = ''.obs;

  final selectedServiceType = ''.obs;
  final selectedFlooringType = ''.obs;
  final selectedApproxArea = ''.obs;

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
    serviceTypeController.dispose();
    flooringTypeController.dispose();
    timeController.dispose();
    approxAreaController.dispose();
    dateController.dispose();
    super.onClose();
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      timeController.text = formattedTime;
      selectedTime.value = formattedTime;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
      selectedDate.value = formattedDate;
    }
  }
}