import 'package:get/get.dart';
import 'package:hello_flutter_app/controller/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}