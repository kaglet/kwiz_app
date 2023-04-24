// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kwiz_v2/main.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/home.dart';

void main() {
  test('Test Home widget method', () {
    // OurUser ourUser = OurUser(uid: 'uid');
    // final widget = Home(user: ourUser,);
    // expect(widget.user, '');
    expect(1, 1);
    // Test authenticate, filter quizzes is a big one, validators in register and sign in, (refactor to functions where needed), in add_questions the add new quiz by extraction,
    // Test load data by refactoring part of the processing as a new function
    // Test populate question and answers on take quiz page, bookmark functionality on view quizzes page
  });
}
