// ignore_for_file: use_build_context_synchronously

import 'package:daily_task_app/bottom_nav_bar/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(
      {super.key,
      this.isFromLogin = false,
      this.question = "",
      this.answer = ""});
  final bool isFromLogin;
  final String question;
  final String answer;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController pin = TextEditingController();
  TextEditingController cPin = TextEditingController();
  TextEditingController answer = TextEditingController();

  setData() {
    if (widget.isFromLogin) {
      option = widget.question;
      answer.text = widget.answer;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  String option = "What is your fav sport?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: widget.isFromLogin,
        centerTitle: true,
        title: Text(
          widget.isFromLogin ? "Reset Pin" : "Sign up",
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 8, top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Set Pin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: Pinput(
                controller: pin,
                obscureText: true,
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Confirm Pin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: Pinput(
                controller: cPin,
                obscureText: true,
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Security Question?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade200),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: option,
                        items: <String>[
                          'What is your fav sport?',
                          'What is your family name?',
                          'First school name?'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          option = val!;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Your answer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: answer,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () async {
                          if (pin.text.length != 4 ||
                              cPin.text.length != 4 ||
                              answer.text == "") {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                                    'please fill all the details',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          } else if (pin.text != cPin.text) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                                    'The pins should be equal',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('pass_key', pin.text);
                            prefs.setString('Security_question', option);
                            prefs.setString(
                                'Security_answer', answer.text.trim());
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavbar()),
                                (route) => false);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.green,
                                content: Center(
                                  child: Text(
                                    widget.isFromLogin
                                        ? "Edited Sucessfully!!"
                                        : 'Thankyou for choosing us!!',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.white),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
