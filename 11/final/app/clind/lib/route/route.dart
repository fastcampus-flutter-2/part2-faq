import 'package:clind/module/module.dart';
import 'package:clind/screen/screen.dart';
import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';

enum ClindRoute {
  root,
  splash,
  unknown;

  static String encode(ClindRoute value) => value.path;

  static ClindRoute decode(String value) => ClindRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => ClindRoute.unknown,
      );
}

extension ClindRouteExtension on ClindRoute {
  String get path {
    const String root = '/';
    if (this == ClindRoute.root) return root;
    return '$root$name';
  }
}

abstract class IClindRoutes {
  static List<ModularRoute> routes = ClindRoute.values.map(_find).toList();

  static ModularRoute _find(ClindRoute route) {
    return ChildRoute(
      route.path,
      child: (context) => find(Uri.parse(route.path)),
      transition: _findTransitionType(route),
    );
  }

  static TransitionType? _findTransitionType(ClindRoute route) {
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
    final ClindRoute route = ClindRoute.decode(uri.path);
    switch (route) {
      case ClindRoute.root:
        return const HomeScreen();
      case ClindRoute.splash:
        return const SplashScreen();
      case ClindRoute.unknown:
        return const SizedBox();
    }
  }

  static Widget findProvider(
    Uri uri, {
    required Widget child,
  }) {
    final ClindRoute route = ClindRoute.decode(uri.path);
    switch (route) {
      case ClindRoute.root:
        return FlowBlocProvider<HomeTabCubit>(
          create: (context) => HomeTabCubit(),
          child: child,
        );
      case ClindRoute.splash:
        return FlowBlocProvider<AdCubit>(
          create: (context) => AdCubit(
            Modular.get<GetAdImageUseCase>(key: '$AppModule$GetAdImageUseCase'),
          ),
          child: child,
        );
      case ClindRoute.unknown:
        return child;
    }
  }
}

abstract class IClindRouteTo {
  static Future<T?> push<T extends Object?>({
    required ClindRoute route,
    Map<String, String>? queryParameters,
  }) {
    return Modular.to.pushNamed<T>(
      route.path,
      arguments: queryParameters,
    );
  }

  static Future<void> root() {
    return push<void>(
      route: ClindRoute.root,
    );
  }
}
