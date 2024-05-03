import 'package:community_domain/domain.dart';
import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:flutter/material.dart';

enum CommunityRoute {
  community,
  post,
  write,
  unknown;

  static String encode(CommunityRoute value) => value.path;

  static CommunityRoute decode(String value) => CommunityRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => CommunityRoute.unknown,
      );
}

extension CommunityRouteExtension on CommunityRoute {
  String get path {
    if (this == CommunityRoute.community) return '/$name';
    return '${CommunityRoute.community.path}/$name';
  }
}

abstract class ICommunityRoutes {
  static List<ModularRoute> routes = CommunityRoute.values.map(_find).toList();

  static ModularRoute _find(CommunityRoute route) {
    return ChildRoute(
      route.path,
      child: (context) => find(Uri.parse(route.path)),
      transition: _findTransitionType(route),
    );
  }

  static TransitionType? _findTransitionType(CommunityRoute route) {
    switch (route) {
      case CommunityRoute.write:
        return TransitionType.downToUp;
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
    final CommunityRoute route = CommunityRoute.decode(uri.path);
    switch (route) {
      case CommunityRoute.community:
        return const CommunityScreen();
      case CommunityRoute.post:
        final String id = Modular.args.data?['id'] as String? ?? '';
        return PostScreen(
          id: id,
        );
      case CommunityRoute.write:
        return const WriteScreen();
      case CommunityRoute.unknown:
        return const SizedBox();
    }
  }

  static Widget findProvider(
    Uri uri, {
    required Widget child,
  }) {
    final CommunityRoute route = CommunityRoute.decode(uri.path);
    switch (route) {
      case CommunityRoute.community:
        return FlowMultiBlocProvider(
          providers: [
            FlowBlocProvider<CommunityChannelListCubit>(
              create: (context) => CommunityChannelListCubit(
                Modular.get<GetChannelsUseCase>(key: '$CommunityModule$GetChannelsUseCase'),
              ),
            ),
            FlowBlocProvider<CommunityPopularChannelListCubit>(
              create: (context) => CommunityPopularChannelListCubit(
                Modular.get<GetPopularChannelsUseCase>(key: '$CommunityModule$GetPopularChannelsUseCase'),
              ),
            ),
            FlowBlocProvider<CommunityPostListCubit>(
              create: (context) => CommunityPostListCubit(
                Modular.get<GetPostsUseCase>(key: '$CommunityModule$GetPostsUseCase'),
              ),
            ),
            FlowBlocProvider<CommunityPopularPostListCubit>(
              create: (context) => CommunityPopularPostListCubit(
                Modular.get<GetPostsUseCase>(key: '$CommunityModule$GetPostsUseCase'),
              ),
            ),
          ],
          child: child,
        );
      case CommunityRoute.post:
        return FlowMultiBlocProvider(
          providers: [
            FlowBlocProvider<PostCubit>(
              create: (context) => PostCubit(
                Modular.get<GetPostUseCase>(key: '$CommunityModule$GetPostUseCase'),
              ),
            ),
            FlowBlocProvider<PostCommentListCubit>(
              create: (context) => PostCommentListCubit(
                Modular.get<GetCommentsUseCase>(key: '$CommunityModule$GetCommentsUseCase'),
              ),
            ),
          ],
          child: child,
        );
      case CommunityRoute.write:
        return FlowMultiBlocProvider(
          providers: [
            FlowBlocProvider<WritePostCubit>(
              create: (context) => WritePostCubit(
                Modular.get<CreatePostUseCase>(key: '$CommunityModule$CreatePostUseCase'),
              ),
            ),
            FlowBlocProvider<WriteMyCubit>(
              create: (context) => WriteMyCubit(
                Modular.get<GetMyUseCase>(key: '$CommunityModule$GetMyUseCase'),
              ),
            ),
          ],
          child: child,
        );
      case CommunityRoute.unknown:
        return child;
    }
  }
}

abstract class ICommunityRouteTo {
  static Future<T?> push<T extends Object?>({
    required CommunityRoute route,
    Map<String, String>? queryParameters,
  }) {
    return Modular.to.pushNamed<T>(
      route.path,
      arguments: queryParameters,
    );
  }

  static Future<void> community() {
    return push<void>(
      route: CommunityRoute.community,
    );
  }

  static Future<void> post({
    required String id,
  }) {
    return push<void>(
      route: CommunityRoute.post,
      queryParameters: {
        'id': id,
      },
    );
  }

  static Future<void> write() {
    return push<void>(
      route: CommunityRoute.write,
    );
  }
}
