import 'package:get/get.dart';

class MessageController extends GetxController {
  var selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}