import 'package:get/get.dart';

import '../../project/controllers/project_controller.dart';

class HomeController extends GetxController {

  final projectName = ''.obs;
  final currentMilestone = 'General'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadContextFromPrefs();
  }

  Future<void> _loadContextFromPrefs() async {
    final pn = await ProjectPrefs.getProjectName();
    final cm = await ProjectPrefs.getCurrentMilestone();
    projectName.value = pn ?? '';
    currentMilestone.value = (cm?.isNotEmpty == true) ? cm! : 'General';
  }
}
