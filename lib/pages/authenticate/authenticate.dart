import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/authenticate/sign_in.dart';
import 'package:kwiz_v2/pages/authenticate/register.dart';
import 'package:kwiz_v2/services/auth.dart';

class Authenticate extends StatefulWidget {
  final AuthService _auth = AuthService();
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  togglieView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: togglieView);
    } else {
      return Register(toggleView: togglieView);
    }
  }
}