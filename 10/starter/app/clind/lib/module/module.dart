import 'package:clind/route/route.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:feature_my/clind.dart';
import 'package:feature_notification/clind.dart';
import 'package:feature_search/clind.dart';
import 'package:tool_clind_network/network.dart';

class AppModule extends Module {
  final String baseUrl;

  AppModule({
    required this.baseUrl,
  });

  @override
  List<Module> get imports => [
        ClindModule(),
        CommunityModule(),
        NotificationModule(),
        MyModule(),
        SearchModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton(() => EventBus());
    i.addSingleton(() => ClindRestClient()..update(baseUrl: baseUrl));

    imports.map((import) => import.binds(i)).toList();
  }

  @override
  void exportedBinds(Injector i) => imports.map((import) => import.exportedBinds(i)).toList();

  @override
  void routes(RouteManager r) => imports.map((import) => import.routes(r)).toList();
}

class ClindModule extends Module {
  @override
  void routes(RouteManager r) {
    for (final ModularRoute route in IClindRoutes.routes) {
      r.add(route);
    }
  }
}
