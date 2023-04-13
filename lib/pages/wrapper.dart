import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // return either the Home or Authenticate widget
    //return Authenticate();
    return const Home();
    
  }
}