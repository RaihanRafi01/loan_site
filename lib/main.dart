import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/dependency_injection.dart';
import 'app/core/dependency_injection_lender.dart';
import 'app/core/services/notification_service.dart';
import 'app/core/services/base_client.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key, // ✅ only one global key
      initialRoute: Routes.SPLASH, // ✅ handled in app_pages.dart
      getPages: AppPages.routes,
      unknownRoute: GetPage(name: Routes.SPLASH, page: () => const SplashView()),  // Add this
    );
  }
}

/// Helper: decide which page to load after splash
Future<String> getInitialRoute() async {
  if (await BaseClient.isLoggedIn()) {
    final role = await BaseClient.getStoredRole();
    if (role == 'borrower') {
      setupDependencies();
      return Routes.DASHBOARD;
    } else if (role == 'private_lender') {
      setupDependenciesLender();
      return Routes.DASHBOARD_LENDER;
    }
  }
  return Routes.AUTH;
}
