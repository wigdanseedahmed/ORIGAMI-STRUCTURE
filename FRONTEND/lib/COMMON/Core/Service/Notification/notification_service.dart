import 'package:origami_structure/imports.dart';

abstract class NotificationService {
  void init(Future<dynamic> Function(int, String?, String?, String?)? onDidReceive);
  Future selectNotification(String? payload);
  void showNotification(TaskModel task, String notificationMessage);
  void scheduleNotificationForBirthday(TaskModel task, String notificationMessage);
  void scheduleNotificationForNextYear(TaskModel task, String notificationMessage);
  void cancelNotificationForBirthday(TaskModel task);
  void cancelAllNotifications();
  void handleApplicationWasLaunchedFromNotification(String payload);
  TaskModel getUserBirthdayFromPayload(String payload);
  Future<List<PendingNotificationRequest>> getAllScheduledNotifications();
}