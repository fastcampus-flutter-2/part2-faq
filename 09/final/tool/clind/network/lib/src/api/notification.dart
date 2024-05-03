import 'package:tool_clind_network/network.dart';

class NotificationApi {
  final ClindRestClient _client;

  const NotificationApi(this._client);

  Future<dynamic> getNotifications() {
    return _client.get<dynamic>('/notification-api/notifications').then((value) => value.data);
  }
}

class MockNotificationApi extends NotificationApi {
  MockNotificationApi(super.client);

  @override
  Future<dynamic> getNotifications() {
    return loadJsonData('assets/json/get_notifications.json');
  }
}
