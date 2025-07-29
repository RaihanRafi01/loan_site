import 'package:get/get.dart';

import '../controllers/project_lender_controller.dart';

class ProjectLenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectLenderController>(
      () => ProjectLenderController(),
    );
  }
}
