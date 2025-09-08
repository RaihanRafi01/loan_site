import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';

// Sets up dependency injection using GetX for the app's dependencies.
void setupDependencies() {

  // Controllers
  Get.put(HomeController());
}