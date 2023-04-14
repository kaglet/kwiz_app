import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:provider/provider.dart';
import 'package:kwiz_v2/pages/authenticate/start_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ourUser?>(context);
    print(user);
    // return either the Home or Authenticate widget
    if (user == null) {
      return StartScreen();
    } else {
      return const Home();
    }
  }
}

// //return Authenticate();
//     return const Home();
    