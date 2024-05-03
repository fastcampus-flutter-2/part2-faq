import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:feature_my/clind.dart';
import 'package:flutter/material.dart';
import 'package:my_domain/domain.dart';
import 'package:my_presentation/presentation.dart';

enum MyRoute {
  my,
  unknown;

  static String encode(MyRoute value) => value.path;

  static MyRoute decode(String value) => MyRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => MyRoute.unknown,
      );
}

extension MyRouteExtension on MyRoute {
  String get path {
    if (this == MyRoute.my) return '/$name';
    return '${MyRoute.my.path}/$name';
  }
}

abstract class IMyRoutes {
  static List<ModularRoute> routes = MyRoute.values.map(_find).toList();

  static ModularRoute _find(MyRoute route) {
    return ChildRoute(
      route.path,
      child: (context) => find(Uri.parse(route.path)),
      transition: _findTransitionType(route),
    );
  }

  static TransitionType? _findTransitionType(MyRoute route) {
    switch (route) {
      default:
        return null;
    }
  }

  static Widget find(Uri uri) {
    return findProvider(
      uri,
      child: findScreen(uri),
    );
  }

  static Widget findScreen(Uri uri) {
    final MyRoute route = MyRoute.decode(uri.path);
    switch (route) {
      case MyRoute.my:
        return const MyScreen();
      case MyRoute.unknown:
        return const SizedBox();
    }
  }

  static Widget findProvider(
    Uri uri, {
    required Widget child,
  }) {
    final MyRoute route = MyRoute.decode(uri.path);

    switch (route) {
      case MyRoute.my:
        return FlowBlocProvider<MyCubit>(
          create: (context) => MyCubit(
            Modular.get<GetMyUseCase>(key: '$MyModule$GetMyUseCase'),
          ),
          child: child,
        );
      case MyRoute.unknown:
        return child;
    }
  }
}

abstract class IMyRouteTo {
  static Future<T?> push<T extends Object?>({
    required MyRoute route,
    Map<String, String>? queryParameters,
  }) {
    return Modular.to.pushNamed<T>(
      route.path,
      arguments: queryParameters,
    );
  }

  static Future<void> my() {
    return push<void>(
      route: MyRoute.my,
    );
  }
}
