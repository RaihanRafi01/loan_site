import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'app/core/dependency_injection.dart';
import 'app/core/dependency_injection_lender.dart';
import 'app/core/services/base_client.dart';
import 'app/core/services/notification_service.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/community/controllers/community_controller.dart';
import 'app/modules/community/views/comments_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initializeNotifications();

  // Initialize CommunityController for post-related operations
  //Get.put(CommunityController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appLinks = AppLinks(); // AppLinks is singleton
  StreamSubscription<Uri>? _linkSubscription;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _setInitialRoute();
    _initAppLinks();
  }

  Future<void> _setInitialRoute() async {
    _initialRoute = await _getInitialRoute();
    setState(() {});
  }

  Future<void> _initAppLinks() async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleDeepLink(initialUri);  // Handle the initial link when the app is opened
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }

    // Subscribe to all events (initial link and further)
    _linkSubscription = appLinks.uriLinkStream.listen(
          (uri) {
        _handleDeepLink(uri);  // Handle deep links coming in while the app is in the foreground
      },
      onError: (err) {
        print('Error in link stream: $err');
      },
    );
  }


  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.scheme == 'yourapp' && uri.host == 'post' && uri.pathSegments.contains('view')) {
      final postIdStr = uri.pathSegments.last;
      final postId = int.tryParse(postIdStr);
      if (postId != null) {
        if (await BaseClient.isLoggedIn()) {
          Get.to(() => CommentsView(postId: postId));  // Navigate to the post's comment view
        } else {
          Get.toNamed(Routes.AUTH, arguments: {'redirectToPostId': postId});  // If not logged in, redirect to the login page
        }
      } else {
        Get.snackbar('Error', 'Invalid post ID in deep link');
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
    // Show a loading screen while initial route is being determined
    if (_initialRoute == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GetMaterialApp(
      title: "Application",
      initialRoute: _initialRoute!,
      getPages: AppPages.routes,
    );
  }
}

Future<String> _getInitialRoute() async {
  // Check if user is logged in via stored token
  if (await BaseClient.isLoggedIn()) {
    final role = await BaseClient.getStoredRole();
    if (role == 'borrower') {
      setupDependencies();
      return Routes.DASHBOARD; // Routes to DashboardView (borrower)
    } else if (role == 'private_lender') {
      setupDependenciesLender();
      return Routes.DASHBOARD_LENDER; // Routes to HomeLenderView (lender)
    }
  }
  return Routes.AUTH; // Routes to LoginScreen (auth)
}