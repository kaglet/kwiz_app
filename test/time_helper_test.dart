// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kwiz_v2/firebase_options.dart';

void main() async {
  late DatabaseService databaseService;
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    databaseService = DatabaseService();
  });

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Add a 5 second delay before running tests
    await Future.delayed(Duration(seconds: 5));
  });
  // TODO 1: Write this
  // When we have a certain dateTime we want that it returns night
  // Unit test for getCategories

  test('getCategories', () async {
    final categories = await databaseService.getCategories();
    expect(categories, isNotNull);
    expect(categories?.length, greaterThan(0));
  });
  test('Add user database function', () async {
    // UserData? currentUser = UserData(
    // uID: ' ',
    // userName: ' ',
    // firstName: ' ',
    // lastName: ' ',
    // bookmarkedQuizzes: [],
    // pastAttemptQuizzes: []);
    UserData? currentUser =
        await databaseService.getUser('8Obchd4CPwR8DAeayeDSZW0LOah1');
    expect(
        currentUser,
        UserData(
            uID: '8Obchd4CPwR8DAeayeDSZW0LOah1',
            userName: 'SmartBoy',
            firstName: 'Aidan',
            lastName: 'Brickhill',
            bookmarkedQuizzes: [],
            pastAttemptQuizzes: []));
  });
  test("Expect one is one", () {
    expect(1, 1);
  });
  // if testing a class and its functions group tests by class then function
  // import class then ask for its function
  // Dependencies to unit test must be remvoed
}
