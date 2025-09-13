import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/controllers/project_controller.dart';

import '../modules/auth/controllers/auth_controller.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/home/controllers/home_controller.dart';

// Sets up dependency injection using GetX for the app's dependencies.
void setupDependencies() {
  Get.put(AuthController());
  // Controllers
  Get.put(HomeController());
  Get.put(ProjectController());
  Get.put(DashboardController());
}