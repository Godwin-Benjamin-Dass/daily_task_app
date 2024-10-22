import 'dart:developer';
import 'package:daily_task_app/main.dart';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/services/task_service.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

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
        onDidReceiveNotificationResponse: (details) =>
            onSelectNotification(details.payload));

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      Permission.notification.request();
    }
  }

  Future<void> onSelectNotification(String? payload) async {
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
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
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
    var androidDetails = AndroidNotificationDetails(
      payload,
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    try {
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
      Fluttertoast.showToast(
          msg: 'You will be notified at $scheduledTime',
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'fail : $e',
          backgroundColor: Colors.red,
          textColor: Colors.white);
      Fluttertoast.showToast(
          msg: 'stat : $id',
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  static Future<void> cancelNotification(int notificationId) async {
    await _localNotificationsPlugin.cancel(notificationId);
  }

  // New function to handle background notifications
  Future<void> triggerBackgroundNotifications() async {
    // Logic to fetch tasks or notifications that should be shown
    List<TaskModel> pendingTasks = await TaskService.getPendingTasks();

    for (TaskModel task in pendingTasks) {
      // Show notifications for each pending task
      await scheduleNotification(
        payload: task.id!,
        scheduledTime: DateTime(
          task.date!.year,
          task.date!.month,
          task.date!.day,
          task.status == 'incomplete'
              ? task.startTime!.hour
              : task.endTime!.hour,
          task.status == 'incomplete'
              ? task.startTime!.minute
              : task.endTime!.minute,
        ), // Immediate notification
        id: int.parse(task.id!),
        title: 'Reminder for Task: ${task.task}',
      );
    }
  }
}
