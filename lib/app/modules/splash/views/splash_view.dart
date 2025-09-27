import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:loan_site/app/modules/auth/views/login_view.dart';
import 'package:loan_site/app/modules/auth/views/signUp_view.dart';

import '../../../core/services/base_client.dart';
import '../../../routes/app_pages.dart';
import '../../../core/dependency_injection.dart';
import '../../../core/dependency_injection_lender.dart';
import '../../community/controllers/community_controller.dart';
import '../../community/views/comments_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final appLinks = AppLinks();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Decide if user is logged in
      String initialRoute = await _getInitialRoute();

      // Check if deep link was used
      final initialUri = await appLinks.getInitialLink();

      if (initialUri != null) {
        await _handleDeepLink(initialUri);
      } else {
        // Normal navigation (login/dashboard)
        Get.offAllNamed(initialRoute);
      }

      // Listen for future deep links
      appLinks.uriLinkStream.listen(
            (uri) {
          _handleDeepLink(uri);
        },
        onError: (err) {
          debugPrint("Deep link stream error: $err");
        },
      );
    } catch (e) {
      debugPrint("Error initializing app: $e");
      Get.offAllNamed(Routes.AUTH);
    }
  }

  Future<void> _handleDeepLink(Uri uri) async {
    debugPrint("Handling deep link: $uri");

    if ((uri.scheme == 'loanapp' && uri.host == 'post' && uri.pathSegments.contains('view')) ||
        (uri.scheme == 'https' &&
            uri.host == 'c81a4b08983f.ngrok-free.app' &&
            uri.pathSegments.length >= 3 &&
            uri.pathSegments[0] == 'deeplink' &&
            uri.pathSegments[1] == 'post' &&
            uri.pathSegments[2] == 'view')) {
      final postIdStr = uri.pathSegments.last;
      final postId = int.tryParse(postIdStr);

      if (postId != null) {
        if (await BaseClient.isLoggedIn()) {
          final role = await BaseClient.getStoredRole();
          if (role == 'borrower') {
            setupDependencies();
          } else if (role == 'private_lender') {
            setupDependenciesLender();
          }
          Get.put(CommunityController());
          Get.offAllNamed(Routes.COMMENTS, arguments: {'postId': postId});
        } else {
          Get.offAllNamed(Routes.AUTH, arguments: {'redirectToPostId': postId});
        }
      } else {
        Get.snackbar('Error', 'Invalid post ID in deep link');
        Get.offAllNamed(Routes.DASHBOARD);  // Or your fallback route
      }
    } else {
      Get.snackbar('Error', 'Invalid deep link format');
      Get.offAllNamed(Routes.DASHBOARD);  // Or your fallback route
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

Future<String> _getInitialRoute() async {
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
