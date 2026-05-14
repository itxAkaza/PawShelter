import 'package:get/get.dart';
import 'gate_pass_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GatePassController>(() => GatePassController());
  }
}