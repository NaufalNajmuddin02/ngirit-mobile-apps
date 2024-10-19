import 'package:get/get.dart';
import 'package:ngirit/app/modules/bataspengeluaran/bindings/batas_pengeluaran_binding.dart';
import 'package:ngirit/app/modules/bataspengeluaran/views/batas_pengeluaran_view.dart';
import 'package:ngirit/app/modules/cashflow/bindings/cash_flow_binding.dart';
import 'package:ngirit/app/modules/cashflow/views/cash_flow_view.dart';
import 'package:ngirit/app/modules/creditcard/bindings/creditcard_binding.dart';
import 'package:ngirit/app/modules/creditcard/views/creditcard_view.dart';
import 'package:ngirit/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:ngirit/app/modules/dashboard/views/dashboard_view.dart';
import 'package:ngirit/app/modules/editsaldo/bindings/editsaldo_binding.dart';
import 'package:ngirit/app/modules/editsaldo/views/editsaldo_view.dart';
import 'package:ngirit/app/modules/profile/bindings/profile_binding.dart';
import 'package:ngirit/app/modules/profile/views/profile_view.dart';
import 'package:ngirit/app/modules/saldo/views/saldo_view.dart';
import 'package:ngirit/app/modules/statistic/bindings/statistic_binding.dart';
import 'package:ngirit/app/modules/statistic/views/statistic_view.dart';
import 'package:ngirit/app/modules/tambahakun/bindings/tambahakun_binding.dart';
import 'package:ngirit/app/modules/tambahakun/views/tambahakun_view.dart';
import 'package:ngirit/app/modules/tambahcc/bindings/tambahcc_binding.dart';
import 'package:ngirit/app/modules/tambahcc/views/tambahcc_view.dart';
import 'package:ngirit/splash_screen/splash_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/masuk/bindings/masuk_binding.dart';
import '../modules/masuk/views/masuk_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/saldo/bindings/saldo_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.MASUK,
      page: () => MasukView(),
      binding: MasukBinding(),
    ),
    GetPage(
      name: _Paths.CASHFLOW,
      page: () => CashFlowView(),
      binding: CashFlowBinding(), // Bind the controller
    ),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => StatisticView(),
      binding: StatisticBinding(), // Pastikan binding diatur
    ),
    GetPage(
      name: _Paths.BATASPENGELUARAN,
      page: () => BatasPengeluaranView(),
      binding: BatasPengeluaranBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SALDO,
      page: () => SaldoView(),
      binding: SaldoBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAHAKUN,
      page: () => TambahakunView(),
      binding: TambahakunBinding(),
    ),
    GetPage(
      name: _Paths.EDITSALDO,
      page: () => EditsaldoView(),
      binding: EditsaldoBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAHCC,
      page: () => const TambahccView(),
      binding: TambahccBinding(),
    ),
    GetPage(
      name: _Paths.CREDITCARD,
      page: () => const CreditcardView(),
      binding: CreditcardBinding(),
    ),
        GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
