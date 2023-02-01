import 'package:origami_structure/imports.dart';
import 'dart:io' show Platform;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String channelID = "123";

class NotificationServiceImpl {
  ///NotificationService a singleton object/Singleton pattern

  ////static const channelID = "123";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void init(Future<dynamic> Function(int, String?, String?, String?)? onDidReceive) {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceive);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    initializeLocalNotificationsPlugin(initializationSettings);

    tz.initializeTimeZones();
  }

  void initializeLocalNotificationsPlugin(
      InitializationSettings initializationSettings) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    handleApplicationWasLaunchedFromNotification("");
  }

  Future selectNotification(String? payload) async {
    TaskModel task = getUserTasksFromPayload(payload ?? '');
    cancelNotificationForBirthday(task);
    scheduleNotificationForBirthday(
        task, "${task.assignedTo} has a task due!");
  }

  void showNotification(TaskModel task,
      String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        task.hashCode,
        applicationName,
        "${task.taskName} has been assigned to you by ${task.assignedBy}",
        NotificationDetails(
          iOS: IOSNotificationDetails(
            subtitle: "${task.taskName} has been assigned to you by ${task.assignedBy}",
          ),
            android: AndroidNotificationDetails(
                channelID,
                applicationName,
                channelDescription: "${task.taskName} has been assigned to you by ${task.assignedBy}")
        ),
        payload: jsonEncode(task)
    );
  }

  void scheduleNotificationForBirthday(TaskModel task,
      String notificationMessage) async {
    DateTime now = DateTime.now();
    DateTime dueDate = DateTime.parse(task.deadlineDate!);
    DateTime correctedDueDate = dueDate;

    if (dueDate.year < now.year) {
      correctedDueDate =
       DateTime(now.year, dueDate.month, dueDate.day);
    }

    Duration difference = now.isAfter(correctedDueDate)
        ? now.difference(correctedDueDate)
        : correctedDueDate.difference(now);

    bool didApplicationLaunchFromNotification = await _wasApplicationLaunchedFromNotification();
    if (didApplicationLaunchFromNotification && difference.inDays == 0) {
      scheduleNotificationForNextYear(task, notificationMessage);
      return;
    } else
    if (!didApplicationLaunchFromNotification && difference.inDays == 0) {
      showNotification(task, notificationMessage);
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channelID,
                applicationName,
                channelDescription: 'To remind you about upcoming tasks due')
        ),
        payload: jsonEncode(task),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  void scheduleNotificationForNextYear(TaskModel task,
      String notificationMessage) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(new Duration(days: 365)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channelID,
                applicationName,
                channelDescription: 'To remind you about upcoming tasks due')
        ),
        payload: jsonEncode(task),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotificationForBirthday(TaskModel task) async {
    await flutterLocalNotificationsPlugin.cancel(task.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleApplicationWasLaunchedFromNotification(String payload) async {
    if (Platform.isIOS) {
      _rescheduleNotificationFromPayload(payload);
      return;
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      _rescheduleNotificationFromPayload(
          notificationAppLaunchDetails.payload ?? "");
    }
  }

  TaskModel getUserTasksFromPayload(String payload) {
    Map<String, dynamic> json = jsonDecode(payload);
    TaskModel task = TaskModel.fromJson(json);
    return task;
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null) {
      return notificationAppLaunchDetails.didNotificationLaunchApp;
    }

    return false;
  }

  void _rescheduleNotificationFromPayload(String payload) {
    TaskModel task = getUserTasksFromPayload(payload);
    cancelNotificationForBirthday(task);
    scheduleNotificationForBirthday(
        task, "${task.assignedTo} has an upcoming task due!");
  }

  Future<
      List<PendingNotificationRequest>> getAllScheduledNotifications() async {
    List<
        PendingNotificationRequest> pendingNotifications = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    return pendingNotifications;
  }

}
