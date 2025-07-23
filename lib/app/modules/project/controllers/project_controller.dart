import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/views/set_milestone_view.dart';

class ProjectController extends GetxController {


  final projectNameController = TextEditingController();
  final projectTypeController = TextEditingController();
  final projectBudgetController = TextEditingController();
  final projectManagerNameController = TextEditingController();
  final projectLocationController = TextEditingController();
  final projectStartDateController = TextEditingController();
  final projectEndDateController = TextEditingController();
  final projectDescriptionController = TextEditingController();


  final contractorNameController = TextEditingController();
  final contractorPhoneController = TextEditingController();
  final contractorAddressController = TextEditingController();
  final contractorEmailController = TextEditingController();
  final contractorLicenseController = TextEditingController();
  final contractorDetailsController = TextEditingController();
  final permitNumberController = TextEditingController();
  final permitTypeController = TextEditingController();
  final permitIssueDateController = TextEditingController();
  final permitExpireDateController = TextEditingController();

  var currentStep = 1.obs;
  var showConfirm = false.obs;

  final contractorControllers = <Map<String, TextEditingController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add one contractor input field by default
    addContractor();
  }
  void showConfirmationAndNavigate() {
    showConfirm.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showConfirm.value = false;
      Get.offAll(() => const SetMilestoneView());
    });
  }

  void addContractor() {
    contractorControllers.add({
      'name': TextEditingController(),
      'phone': TextEditingController(),
      'email': TextEditingController(),
      'license': TextEditingController(),
      'details': TextEditingController(),
    });
  }


}
