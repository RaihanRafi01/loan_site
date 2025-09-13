import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/dependency_injection.dart';
import 'app/core/services/base_client.dart';
import 'app/core/services/notification_service.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencies();
  await NotificationService().initializeNotifications();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: await _getInitialRoute(),
      getPages: AppPages.routes,
    ),
  );
}

Future<String> _getInitialRoute() async {
  // Check if user is logged in via stored token
  if (await BaseClient.isLoggedIn()) {
    final role = await BaseClient.getStoredRole();
    if (role == 'borrower') {
      return Routes.DASHBOARD; // Routes to DashboardView (borrower)
    } else if (role == 'private_lender') {
      return Routes.DASHBOARD_LENDER; // Routes to HomeLenderView (lender)
    }
  }
  return Routes.AUTH; // Routes to LoginScreen (auth)
}