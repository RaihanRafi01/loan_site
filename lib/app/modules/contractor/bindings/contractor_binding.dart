import 'package:get/get.dart';

import '../controllers/contractor_controller.dart';

class ContractorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorController>(
      () => ContractorController(),
    );
  }
}
