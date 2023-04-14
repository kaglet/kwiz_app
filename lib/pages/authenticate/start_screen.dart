import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/authenticate/authenticate.dart';
import 'package:kwiz_v2/pages/authenticate/register.dart';
import 'package:kwiz_v2/pages/authenticate/sign_in.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "KWIZ",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () {
                // navigate to the registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Register(
                            toggleView: null,
                          )),
                );
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // navigate to the sign in screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignIn(
                            toggleView: null,
                          )),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
