import 'package:community_data/data.dart';
import 'package:community_domain/domain.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:tool_clind_network/network.dart';

class CommunityModule extends Module {
  @override
  void binds(Injector i) {
    /// Remote Data Source
    i.addLazySingleton<IPostRemoteDataSource>(
      () => PostRemoteDataSource(PostApi(Modular.get<ClindRestClient>())),
      key: '$CommunityModule$IPostRemoteDataSource',
    );
    i.addLazySingleton<IProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(ProfileApi(Modular.get<ClindRestClient>())),
      key: '$CommunityModule$IProfileRemoteDataSource',
    );

    /// Data Source
    i.addLazySingleton<CommunityDataSource>(
      () => CommunityDataSource(
        i.get<IPostRemoteDataSource>(key: '$CommunityModule$IPostRemoteDataSource'),
      ),
      key: '$CommunityModule$CommunityDataSource',
    );
    i.addLazySingleton<PostDataSource>(
      () => PostDataSource(
        i.get<IPostRemoteDataSource>(key: '$CommunityModule$IPostRemoteDataSource'),
      ),
      key: '$CommunityModule$PostDataSource',
    );
    i.addLazySingleton<WriteDataSource>(
      () => WriteDataSource(
        i.get<IPostRemoteDataSource>(key: '$CommunityModule$IPostRemoteDataSource'),
        i.get<IProfileRemoteDataSource>(key: '$CommunityModule$IProfileRemoteDataSource'),
      ),
      key: '$CommunityModule$WriteDataSource',
    );

    /// Repository
    i.addLazySingleton<ICommunityRepository>(
      () => CommunityRepository(
        i.get<CommunityDataSource>(key: '$CommunityModule$CommunityDataSource'),
      ),
      key: '$CommunityModule$ICommunityRepository',
    );
    i.addLazySingleton<IPostRepository>(
      () => PostRepository(
        i.get<PostDataSource>(key: '$CommunityModule$PostDataSource'),
      ),
      key: '$CommunityModule$IPostRepository',
    );
    i.addLazySingleton<IWriteRepository>(
      () => WriteRepository(
        i.get<WriteDataSource>(key: '$CommunityModule$WriteDataSource'),
      ),
      key: '$CommunityModule$IWriteRepository',
    );

    /// Use Case
    i.addLazySingleton<GetChannelsUseCase>(
      () => GetChannelsUseCase(
        i.get<ICommunityRepository>(key: '$CommunityModule$ICommunityRepository'),
      ),
      key: '$CommunityModule$GetChannelsUseCase',
    );
    i.addLazySingleton<GetPopularChannelsUseCase>(
      () => GetPopularChannelsUseCase(
        i.get<ICommunityRepository>(key: '$CommunityModule$ICommunityRepository'),
      ),
      key: '$CommunityModule$GetPopularChannelsUseCase',
    );
    i.addLazySingleton<GetPostsUseCase>(
      () => GetPostsUseCase(
        i.get<ICommunityRepository>(key: '$CommunityModule$ICommunityRepository'),
      ),
      key: '$CommunityModule$GetPostsUseCase',
    );
    i.addLazySingleton<GetPostUseCase>(
      () => GetPostUseCase(
        i.get<IPostRepository>(key: '$CommunityModule$IPostRepository'),
      ),
      key: '$CommunityModule$GetPostUseCase',
    );
    i.addLazySingleton<GetCommentsUseCase>(
      () => GetCommentsUseCase(
        i.get<IPostRepository>(key: '$CommunityModule$IPostRepository'),
      ),
      key: '$CommunityModule$GetCommentsUseCase',
    );
    i.addLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(
        i.get<IWriteRepository>(key: '$CommunityModule$IWriteRepository'),
      ),
      key: '$CommunityModule$CreatePostUseCase',
    );
    i.addLazySingleton<GetMyUseCase>(
      () => GetMyUseCase(
        i.get<IWriteRepository>(key: '$CommunityModule$IWriteRepository'),
      ),
      key: '$CommunityModule$GetMyUseCase',
    );
  }

  @override
  void routes(RouteManager r) {
    for (final ModularRoute route in ICommunityRoutes.routes) {
      r.add(route);
    }
  }
}
