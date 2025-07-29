import 'package:get/get.dart';

import '../controllers/home_lender_controller.dart';

class HomeLenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLenderController>(
      () => HomeLenderController(),
    );
  }
}
