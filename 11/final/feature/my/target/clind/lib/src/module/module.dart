import 'package:core_util/util.dart';
import 'package:feature_my/clind.dart';
import 'package:my_data/data.dart';
import 'package:my_domain/domain.dart';
import 'package:tool_clind_network/network.dart';

class MyModule extends Module {
  @override
  void binds(Injector i) {
    /// Remote Data Source
    i.addLazySingleton<IProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(ProfileApi(Modular.get<ClindRestClient>())),
      key: '$MyModule$IProfileRemoteDataSource',
    );

    /// Data Source
    i.addLazySingleton<MyDataSource>(
      () => MyDataSource(
        i.get<IProfileRemoteDataSource>(key: '$MyModule$IProfileRemoteDataSource'),
      ),
      key: '$MyModule$MyDataSource',
    );

    /// Repository
    i.addLazySingleton<IMyRepository>(
      () => MyRepository(
        i.get<MyDataSource>(key: '$MyModule$MyDataSource'),
      ),
      key: '$MyModule$IMyRepository',
    );

    /// Use Case
    i.addLazySingleton<GetMyUseCase>(
      () => GetMyUseCase(
        i.get<IMyRepository>(key: '$MyModule$IMyRepository'),
      ),
      key: '$MyModule$GetMyUseCase',
    );
  }

  @override
  void routes(RouteManager r) {
    for (final ModularRoute route in IMyRoutes.routes) {
      r.add(route);
    }
  }
}
