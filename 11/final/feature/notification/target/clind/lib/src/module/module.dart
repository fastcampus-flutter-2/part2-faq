import 'package:core_util/util.dart';
import 'package:feature_notification/clind.dart';
import 'package:notification_data/data.dart';
import 'package:notification_domain/domain.dart';
import 'package:tool_clind_network/network.dart';

class NotificationModule extends Module {
  @override
  void binds(Injector i) {
    /// Remote Data Source
    i.addLazySingleton<INotificationRemoteDataSource>(
      () => NotificationRemoteDataSource(NotificationApi(Modular.get<ClindRestClient>())),
      key: '$NotificationModule$INotificationRemoteDataSource',
    );

    /// Data Source
    i.addLazySingleton<NotificationDataSource>(
      () => NotificationDataSource(
        i.get<INotificationRemoteDataSource>(key: '$NotificationModule$INotificationRemoteDataSource'),
      ),
      key: '$NotificationModule$NotificationDataSource',
    );

    /// Repository
    i.addLazySingleton<INotificationRepository>(
      () => NotificationRepository(
        i.get<NotificationDataSource>(key: '$NotificationModule$NotificationDataSource'),
      ),
      key: '$NotificationModule$INotificationRepository',
    );

    /// Use Case
    i.addLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(
        i.get<INotificationRepository>(key: '$NotificationModule$INotificationRepository'),
      ),
      key: '$NotificationModule$GetNotificationsUseCase',
    );
  }

  @override
  void routes(RouteManager r) {
    for (final ModularRoute route in INotificationRoutes.routes) {
      r.add(route);
    }
  }
}
