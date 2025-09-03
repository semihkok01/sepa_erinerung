import 'package:get/get.dart';

import '../modules/archive/bindings/archive_binding.dart';
import '../modules/archive/views/archive_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/stats/bindings/stats_binding.dart';
import '../modules/stats/views/stats_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ARCHIVE,
      page: () => const ArchiveView(),
      binding: ArchiveBinding(),
    ),
    GetPage(
      name: _Paths.STATS,
      page: () => const StatsView(),
      binding: StatsBinding(),
    ),
  ];
}
