import 'package:get/get.dart';
import '../controllers/batas_pengeluaran_controller.dart';

class BatasPengeluaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatasPengeluaranController>(() => BatasPengeluaranController());
  }
}
