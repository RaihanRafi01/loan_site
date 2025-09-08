import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import '../../../../common/appColors.dart';
import '../../project/controllers/project_controller.dart';

class HomeController extends GetxController {
  final currentProject = Rxn<ProjectDetail>();

  @override
  void onInit() {
    super.onInit();
    loadContextFromPrefs();
  }

  Future<void> loadContextFromPrefs() async {
    try {
      final project = await ProjectPrefs.getCurrentProject();
      currentProject.value = project;
      debugPrint('===========================HomeController: Loaded project: ${project?.name}');
    } catch (e) {
      debugPrint('HomeController: Error loading project context: $e');
    }
  }

  // Method to manually refresh context
  Future<void> refreshContext() async {
    await loadContextFromPrefs();
  }
}