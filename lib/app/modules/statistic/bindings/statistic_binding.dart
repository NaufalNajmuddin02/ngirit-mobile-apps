import 'package:get/get.dart';
import 'package:ngirit/app/modules/statistic/controllers/statistic_controller.dart';

class StatisticBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticController>(() => StatisticController());
  }
}
