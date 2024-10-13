// import 'package:daily_task_app/home_flow/home_screen.dart';
import 'dart:developer';

import 'package:daily_task_app/main.dart';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/services/task_service.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  static late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  NotificationService._internal();

  Future<void> initNotification(BuildContext? context) async {
    tz.initializeTimeZones();
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    // Request permission after initialization
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      Permission.notification.request();
    }
  }

  Future onSelectNotification(String? payload) async {
    // Show popup when notification is clicked
    if (payload != null) {
      log(payload);

      TaskModel? task = await TaskService.getTaskById(payload);
      if (task == null) {
        return;
      }
      showDialogs(task);
    }
  }

  static Future<void> showDialogs(TaskModel task) async {
    // Get the current context to show the dialog
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,

            // title: const Text("Notification Data Nigga"),
            content: TaskTileWidget(
              isNotificationPopUp: true,
              isAnalyseTask: true,
              ontap: () {},
              task: task,
              idx: 0,
            ),
          );
        },
      );
    }
  }

  static Future<void> scheduleNotification({
    required String payload,
    required DateTime scheduledTime,
    id,
    required String title,
  }) async {
    log('sheduled success==============>$scheduledTime');
    var androidDetails = AndroidNotificationDetails(
      payload,
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      'Tap to see details',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await _localNotificationsPlugin.cancel(notificationId);
  }
}
