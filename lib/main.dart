import 'package:daily_task_app/login_flow/login_page.dart';
import 'package:daily_task_app/login_flow/registerPage.dart';
import 'package:daily_task_app/providers/profile_provider.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var key = prefs.getString('pass_key');
  debugPrint(key);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ChangeNotifierProvider(create: (context) => TaskProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: key == null ? const RegisterPage() : const LoginPage(),
      theme: ThemeData(
          fontFamily: "Work Sans",
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xff0D4194))),
    ),
  ));
}
