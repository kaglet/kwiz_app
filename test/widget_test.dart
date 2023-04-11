// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kwiz_v2/main.dart';
import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/view_categories.dart';

void main() {
  testWidgets('Home screen buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    expect(find.text('Browse our quizzes'), findsOneWidget);
    expect(find.text('Add custom quiz'), findsOneWidget);

    await tester.tap(find.text('Browse our quizzes'));
    await tester.pumpAndSettle();
    expect(find.byType(ViewCategories), findsOneWidget);
  });
}
