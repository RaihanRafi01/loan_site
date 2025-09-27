import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'app/core/dependency_injection.dart';
import 'app/core/dependency_injection_lender.dart';
import 'app/core/services/base_client.dart';
import 'app/core/services/notification_service.dart';
import 'app/modules/community/views/comments_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _initialRoute;
  bool _initialLinkHandled = false;
  DateTime? _lastLinkHandled;

  @override
  void initState() {
    super.initState();
    _setInitialRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAppLinks();
    });
  }

  Future<void> _setInitialRoute() async {
    _initialRoute = await _getInitialRoute();
    setState(() {});
  }

  Future<void> _initAppLinks() async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null && !_initialLinkHandled) {
        _initialLinkHandled = true;
        await _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }

    _linkSubscription = appLinks.uriLinkStream.listen(
          (uri) {
        print('Handling deep link: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('Error in link stream: $err');
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (_lastLinkHandled != null &&
        DateTime.now().difference(_lastLinkHandled!).inMilliseconds < 1000) {
      print('Deep link debounced (duplicate call ignored)');
      return;
    }
    _lastLinkHandled = DateTime.now();

    if ((uri.scheme == 'loanapp' && uri.host == 'post' && uri.pathSegments.contains('view')) ||
        (uri.scheme == 'https' && uri.host == 'c81a4b08983f.ngrok-free.app' && uri.pathSegments.length >= 3 && uri.pathSegments[0] == 'deeplink' && uri.pathSegments[1] == 'post' && uri.pathSegments[2] == 'view')) {
      final postIdStr = uri.pathSegments.last;
      final postId = int.tryParse(postIdStr);
      if (postId != null) {
        if (await BaseClient.isLoggedIn()) {
          if (Get.currentRoute != Routes.COMMENTS) {
            Get.to(() => CommentsView(postId: postId));
          }
        } else {
          if (Get.currentRoute != Routes.AUTH) {
            Get.offAndToNamed(Routes.AUTH, arguments: {'redirectToPostId': postId});
          }
        }
      } else {
        Get.snackbar('Error', 'Invalid post ID in deep link');
        if (Get.currentRoute != Routes.DASHBOARD) {
          Get.offAndToNamed(Routes.DASHBOARD);
        }
      }
    } else {
      Get.snackbar('Error', 'Invalid deep link format');
      if (Get.currentRoute != Routes.DASHBOARD) {
        Get.offAndToNamed(Routes.DASHBOARD);
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GetMaterialApp(
      title: "Application",
      initialRoute: _initialRoute!,
      getPages: AppPages.routes,
      navigatorKey: Get.key, // Ensure single Navigator key
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