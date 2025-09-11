import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContractorController extends GetxController {
  var currentPage = 0.obs;
  var showConfirm = false.obs;

  final PageController pageController = PageController();

  // Text controllers for form inputs
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final flooringTypeController = TextEditingController();
  final approxAreaController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  // Rx variables for dropdowns
  var selectedServiceType = ''.obs;
  var selectedFlooringType = ''.obs;
  var selectedApproxArea = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    serviceTypeController.dispose();
    flooringTypeController.dispose();
    approxAreaController.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    timeController.dispose();
    dateController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // Method to select time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  // Method to select date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Method to open email client with pre-filled form data
  Future<void> openEmailClient() async {
    // Construct the email body
    final String emailBody = '''
New Schedule Submission:

Client Information:
- Full Name: ${nameController.text.isEmpty ? 'Not specified' : nameController.text}
- Email: ${emailController.text.isEmpty ? 'Not specified' : emailController.text}
- Phone Number: ${phoneController.text.isEmpty ? 'Not specified' : phoneController.text}

Service Details:
- Service Type: ${selectedServiceType.value.isEmpty ? 'Not specified' : selectedServiceType.value}
- Flooring Type: ${selectedFlooringType.value.isEmpty ? 'Not specified' : selectedFlooringType.value}
- Approx. Area: ${selectedApproxArea.value.isEmpty ? 'Not specified' : selectedApproxArea.value}

Appointment Schedule:
- Date: ${dateController.text.isEmpty ? 'Not specified' : dateController.text}
- Time: ${timeController.text.isEmpty ? 'Not specified' : timeController.text}

Location:
- Address: ${addressController.text.isEmpty ? 'Not specified' : addressController.text}
- City: ${cityController.text.isEmpty ? 'Not specified' : cityController.text}
- Province: ${provinceController.text.isEmpty ? 'Not specified' : provinceController.text}
''';

    // Encode the subject and body to handle special characters
    final String encodedSubject = Uri.encodeComponent('New Schedule Submission - ${DateTime.now()}');
    final String encodedBody = Uri.encodeComponent(emailBody);

    // Construct the mailto URL
    final String mailtoUrl = 'mailto:recipient-email@example.com?subject=$encodedSubject&body=$encodedBody';
    final Uri emailUri = Uri.parse(mailtoUrl);

    print('Attempting to launch URL: $mailtoUrl'); // Debug log

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        print('Cannot launch email client: No email client available');
        Get.snackbar('Error', 'No email client found on this device. Please install an email app.');
      }
    } catch (e) {
      print('Error launching email client: $e');
      Get.snackbar('Error', 'Failed to open email client: $e');
    }
  }
}