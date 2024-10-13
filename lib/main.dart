import 'package:daily_task_app/login_flow/login_page.dart';
import 'package:daily_task_app/login_flow/registerPage.dart';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/providers/profile_provider.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/services/notification_service.dart';
import 'package:daily_task_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isNotified = false;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize the notification service
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await NotificationService().initNotification(navigatorKey.currentContext);

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
        navigatorKey: navigatorKey, // Use the global navigator key
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
      // App was launched by clicking the notification
      String? payload = notificationAppLaunchDetails.payload;

      if (payload != null) {
        TaskModel? task = await TaskService.getTaskById(payload);
        if (task == null) {
          return;
        }
        NotificationService.showDialogs(task);
      }
    } else {
      // App was opened directly
    }
  }
}
