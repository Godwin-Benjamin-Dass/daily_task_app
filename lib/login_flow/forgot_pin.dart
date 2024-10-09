import 'package:daily_task_app/login_flow/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class forgotPin extends StatefulWidget {
  const forgotPin({super.key, this.isFromHome = false});
  final bool isFromHome;

  @override
  State<forgotPin> createState() => _forgotPinState();
}

class _forgotPinState extends State<forgotPin> {
  TextEditingController answer = TextEditingController();
  String? question;
  String? ans;

  fetchAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    question = prefs.getString('Security_question')!;
    ans = prefs.getString('Security_answer')!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.isFromHome ? "Reset Pin" : 'Forgot PIN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              question ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: answer,
              decoration: InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  fillColor: Colors.grey.shade200,
                  filled: true),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      if (ans == answer.text) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                    isFromLogin: true,
                                    answer: ans!,
                                    question: question!,
                                  )),
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
                                'Please enter the valid answer!!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )))
          ],
        ),
      ),
    );
  }
}
