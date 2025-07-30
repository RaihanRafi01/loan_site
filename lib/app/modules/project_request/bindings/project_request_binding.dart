import 'package:get/get.dart';

import '../controllers/project_request_controller.dart';

class ProjectRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectRequestController>(
      () => ProjectRequestController(),
    );
  }
}
