// ignore_for_file: use_build_context_synchronously

import 'package:daily_task_app/bottom_nav_bar/bottom_navbar.dart';
import 'package:daily_task_app/login_flow/forgot_pin.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    "Welcome Back !",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontVariations: const [FontVariation('wght', 700)],
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Image.asset(
                  //   "assets/images/logo.png",
                  //   color: Theme.of(context).primaryColor,
                  //   height: MediaQuery.of(context).size.height * .1,
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  const Text(
                    "PIN Verification",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Enter the 4 Digit code",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff868889)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    controller: pin,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String key = prefs.getString('pass_key')!;
                            if (key == pin.text) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavbar()),
                                  (route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  elevation: 6,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.green,
                                  content: const Center(
                                    child: Text(
                                      'Loging in!!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  elevation: 6,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.red,
                                  content: const Center(
                                    child: Text(
                                      'Please give the right pin!!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                              pin.clear();
                            }
                          },
                          child: const Text(
                            "Verify",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const forgotPin()));
                          },
                          child: const Text("Forgot pin?")))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
