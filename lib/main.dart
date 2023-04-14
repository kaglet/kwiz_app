import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/wrapper.dart';
import 'package:kwiz_v2/pages/profile.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/auth.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(StreamProvider<ourUser?>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 27, 57, 82),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
      ),
    ),
    home: Home(),
  ));
}
