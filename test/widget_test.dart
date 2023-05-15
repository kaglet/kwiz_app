// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kwiz_v2/main.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/home.dart';

void main() {
  testWidgets("HomeWidget", (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await tester
        .pumpWidget(Home(user: OurUser(uid: 'Lat9DYQyjGhhIEarIj8JLu7rutD3')));

    await tester.pump();

    final greetingFinder = find.text("Good Evening mchlkavai!");
    expect(greetingFinder, findsOneWidget);
  });
}
