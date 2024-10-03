import 'package:get/get.dart';
import '../controllers/cash_flow_controller.dart';

class CashFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CashFlowController>(() => CashFlowController());
  }
}
