import 'package:core_util/util.dart';
import 'package:feature_search/clind.dart';
import 'package:search_data/data.dart';
import 'package:search_domain/domain.dart';
import 'package:tool_clind_network/network.dart';

class SearchModule extends Module {
  @override
  void binds(Injector i) {
    /// Local Data Source
    i.addLazySingleton<IPreferenceLocalDataSource>(
      () => const PreferenceLocalDataSource(),
      key: '$SearchModule$IPreferenceLocalDataSource',
    );

    /// Remote Data Source
    i.addLazySingleton<IPostRemoteDataSource>(
      () => PostRemoteDataSource(PostApi(Modular.get<ClindRestClient>())),
      key: '$SearchModule$IPostRemoteDataSource',
    );

    /// Data Source
    i.addLazySingleton<SearchDataSource>(
      () => SearchDataSource(
        i.get<IPreferenceLocalDataSource>(key: '$SearchModule$IPreferenceLocalDataSource'),
        i.get<IPostRemoteDataSource>(key: '$SearchModule$IPostRemoteDataSource'),
      ),
      key: '$SearchModule$SearchDataSource',
    );

    /// Repository
    i.addLazySingleton<ISearchRepository>(
      () => SearchRepository(
        i.get<SearchDataSource>(key: '$SearchModule$SearchDataSource'),
      ),
      key: '$SearchModule$ISearchRepository',
    );

    /// Use Case
    i.addLazySingleton<SetRecentSearchChannelsUseCase>(
      () => SetRecentSearchChannelsUseCase(
        i.get<ISearchRepository>(key: '$SearchModule$ISearchRepository'),
      ),
      key: '$SearchModule$SetRecentSearchChannelsUseCase',
    );
    i.addLazySingleton<GetRecentSearchChannelsUseCase>(
      () => GetRecentSearchChannelsUseCase(
        i.get<ISearchRepository>(key: '$SearchModule$ISearchRepository'),
      ),
      key: '$SearchModule$GetRecentSearchChannelsUseCase',
    );
    i.addLazySingleton<GetPopularChannelsUseCase>(
      () => GetPopularChannelsUseCase(
        i.get<ISearchRepository>(key: '$SearchModule$ISearchRepository'),
      ),
      key: '$SearchModule$GetPopularChannelsUseCase',
    );
    i.addLazySingleton<GetSearchPostsUseCase>(
      () => GetSearchPostsUseCase(
        i.get<ISearchRepository>(key: '$SearchModule$ISearchRepository'),
      ),
      key: '$SearchModule$GetSearchPostsUseCase',
    );
  }

  @override
  void routes(RouteManager r) {
    for (final ModularRoute route in ISearchRoutes.routes) {
      r.add(route);
    }
  }
}
