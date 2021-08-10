import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';
import 'package:the/tdd/features/notifications/domain/usecases/fetch_notifications.dart';
import 'package:the/tdd/features/notifications/domain/usecases/get_viewed_notifications.dart';
import 'package:the/tdd/features/notifications/domain/usecases/save_viewed_notifications.dart';

class NotificationsProvider extends BaseProvider {
  final FetchNotifications _fetchNotifications;
  final GetViewedNotifications _getViewedNotifications;
  final SaveViewedNotification _saveViewedNotification;

  NotificationsProvider(
    this._fetchNotifications,
    this._getViewedNotifications,
    this._saveViewedNotification,
  );

  List<Notification> _notifications = [];
  List<Notification> get notifications => [..._notifications];

  List<String> _viewedNotifications = [];

  Future<void> fetchNotifications() async {
    final remoteResult = await _fetchNotifications(NoParams());
    final localResult = await _getViewedNotifications(NoParams());

    remoteResult.fold(
      (failure) => null,
      (notifications) => _notifications = notifications,
    );

    localResult.fold(
      (failure) => null,
      (notificationIDs) => _viewedNotifications = notificationIDs,
    );

    notifyListeners();
  }

  Future<void> saveViewedNotification(
    SaveViewedNotificationParams params,
  ) async {
    final result = await _saveViewedNotification(params);
    result.fold((failure) => null, (value) {
      _viewedNotifications.add(params.notificationId);
      notifyListeners();
    });
  }

  bool isNotificationsViewed(String notificationId) =>
      _viewedNotifications.contains(notificationId);

  int get numberOfViewedNotifications {
    int result = 0;
    notifications.forEach(
      (notification) =>
          result += _viewedNotifications.contains(notification.id) ? 0 : 1,
    );
    return result;
  }
}
