import 'package:daily_task_app/login_flow/login_page.dart';
import 'package:daily_task_app/login_flow/registerPage.dart';
import 'package:daily_task_app/providers/profile_provider.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/services/notification_service.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isNotified = false;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Trigger the existing check and notification logic
    await NotificationService().triggerBackgroundNotifications();
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize the notification service
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await NotificationService().initNotification(navigatorKey.currentContext);
  bool? isAutoStartEnabled =
      await DisableBatteryOptimization.isAutoStartEnabled;
  if (isAutoStartEnabled == false || isAutoStartEnabled == null) {
    await DisableBatteryOptimization.showEnableAutoStartSettings(
        "Enable Auto Start",
        "Follow the steps and enable the auto start of this app");
  }
  // Initialize WorkManager for background tasks
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Schedule a periodic background task
  Workmanager().registerPeriodicTask(
    "notification-task", // Unique name for the task
    "background_notification", // Task ID
    frequency: const Duration(minutes: 1), // Interval for the background task
  );

  var key = prefs.getString('pass_key');
  debugPrint(key);

  runApp(MyApp(skey: key));
}

class MyApp extends StatefulWidget {
  final String? skey;

  const MyApp({super.key, this.skey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkNotificationFlag(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: widget.skey == null ? const RegisterPage() : const LoginPage(),
        theme: ThemeData(
          fontFamily: "Work Sans",
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xff0D4194)),
        ),
      ),
    );
  }

  void _checkNotificationFlag(BuildContext context) async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin!
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      String? payload =
          notificationAppLaunchDetails.notificationResponse!.payload;

      if (payload != null) {
        NotificationService().onSelectNotification(payload);
      }
    }
  }
}
