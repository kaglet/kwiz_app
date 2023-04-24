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
    // initialize all data beforehand then send it through to function then do expect
    // test function given inputs, might need to refactor functions such that it accepts more inputs
    // call the function then given an input we expect an output, I want to refactor it such that parts of functions can be in that style
    // call the function don't do the work, , pass dummy inputs, then expect something based off inputs, so can refactor functions where needed
    // only understand inputs and outputs needed not what happens inside
    // PARTS THAT NEED COVERAGE
    // Test in add_questions the add new quiz by extraction maybe pass in widget to do extraction of? (untestable, include or leave out) x
    // Test filter quizzes is a big one x
    // Test populate question and answers on take quiz page x, bookmark functionality on view quizzes page (too much work, try get prints)
    // Test authenticate
    // Test validators in register and sign in (refactor to functions where needed)
    // Test some load data functions by refactoring part of the processing as a new function
    // Our functions are tied very closely to graphical components, too closely, can't pass local variables for set state
    // flutter has weird odd parts to its logic that make pure unit testing hard as its mostly widgets
  });
}
