// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kwiz_v2/main.dart';

void main() {
  // TODO 1: Write this
  // When we have a certain dateTime we want that it returns night
  // if testing a class and its functions group tests by class then function
  // import class then ask for its function
  // Dependencies to unit test must be remvoed
  test('One should be one', () {
    // Arrange
    int expectedNumber = 1;
    // Act

    // Assert
    expect(expectedNumber, 2);
  });
}
