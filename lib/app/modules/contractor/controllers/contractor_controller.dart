import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../home/controllers/home_controller.dart';


class Contractor {
  final String name;
  final bool availableThisWeek;
  final String address;
  final String phone;
  final String email;
  final String website;
  final double rating;
  final int totalReviews;
  final List<String> specialties;
  final List<String> servicesIncluded;
  final Map<String, String> pricing;
  final List<String> reviews;
  final String? image;

  Contractor({
    required this.name,
    required this.availableThisWeek,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.rating,
    required this.totalReviews,
    required this.specialties,
    required this.servicesIncluded,
    required this.pricing,
    required this.reviews,
    this.image,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      name: json['name'] ?? '',
      availableThisWeek: json['available_this_week'] ?? false,
      address: json['address'] ?? '',
      phone: json['phone'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      website: json['website'] ?? 'N/A',
      rating: json['rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      specialties: List<String>.from(json['specialties'] ?? []),
      servicesIncluded: List<String>.from(json['services_included'] ?? []),
      pricing: Map<String, String>.from(json['pricing'] ?? {}),
      reviews: List<String>.from(json['reviews'] ?? []),
      image: json['image'],
    );
  }
}

class ContractorController extends GetxController {
  var currentPage = 0.obs;
  var showConfirm = false.obs;
  var contractors = <Contractor>[].obs; // Observable list for contractors
  var isContractorsLoading = false.obs; // Loading state
  var contractorsError = Rxn<String>(); // Error state
  var hasMilestone = true.obs; // New observable to track milestone availability

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
  void onInit() {
    super.onInit();
    fetchContractors(); // Fetch contractors when controller initializes
  }

  Future<void> launch(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

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

  // Method to fetch contractors from API
  Future<void> fetchContractors() async {
    final HomeController homeController = Get.find<HomeController>();
    final currentProject = homeController.currentProject.value;

    if (currentProject == null || currentProject.milestones.isEmpty) {
      hasMilestone.value = false; // No milestones available
      contractors.clear();
      debugPrint('ContractorController: No project or milestones available');
      return;
    }

    // Find the first milestone with 'on_going' status
    var milestone = currentProject.milestones
        .firstWhereOrNull((m) => m.status == 'on_going');

    // If no ongoing milestone, check for completed milestones
    if (milestone == null) {
      final completedMilestones = currentProject.milestones
          .where((m) => m.status == 'completed')
          .toList();
      if (completedMilestones.isNotEmpty) {
        // Select the last completed milestone
        milestone = completedMilestones.last;
        debugPrint('ContractorController: Using last completed milestone: ${milestone.id} - ${milestone.name}');
      } else {
        hasMilestone.value = false; // No ongoing or completed milestones
        contractors.clear();
        debugPrint('ContractorController: No ongoing or completed milestones');
        return;
      }
    }

    debugPrint('ContractorController: Selected milestone: ${milestone?.id} - ${milestone?.name}');

    try {
      isContractorsLoading.value = true;
      contractorsError.value = null;
      debugPrint('ContractorController: Fetching contractors');

      final response = await BaseClient.getRequest(
        api: Api.getContractors(milestone?.id), // Assume Api.contractors() returns the endpoint
        headers: BaseClient.authHeaders(),
      );

      final data = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getContractors(milestone?.id),
          headers: BaseClient.authHeaders(),
        ),
      );

      debugPrint('ContractorController: Raw API response: $data');

      if (data is! Map<String, dynamic> || data['contractors'] is! List) {
        throw Exception('Invalid response format: Expected a JSON object with contractors list');
      }

      contractors.value = (data['contractors'] as List)
          .map((json) => Contractor.fromJson(json))
          .toList();
      debugPrint('ContractorController: Loaded ${contractors.length} contractors');
    } catch (e, stackTrace) {
      debugPrint('ContractorController: Error fetching contractors: $e\nStackTrace: $stackTrace');
      contractorsError.value = 'Failed to fetch contractors: $e';
      contractors.clear();
    } finally {
      isContractorsLoading.value = false;
    }
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

    final String encodedSubject = Uri.encodeComponent('New Schedule Submission - ${DateTime.now()}');
    final String encodedBody = Uri.encodeComponent(emailBody);
    final String mailtoUrl = 'mailto:recipient-email@example.com?subject=$encodedSubject&body=$encodedBody';
    final Uri emailUri = Uri.parse(mailtoUrl);

    print('Attempting to launch URL: $mailtoUrl');

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