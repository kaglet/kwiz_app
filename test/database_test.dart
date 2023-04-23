import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kwiz_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/quizzes.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/services/mock_database.dart';

void main() {
  test('Get categories', () async {
    final service = MockDataService();
    final List? testCategories = await service.getCategories();

    expect(testCategories, ['Art', 'Science']);
  });

  test('Add quiz with questions', () async {
    final service = MockDataService();

    Quiz quiz = Quiz(
        quizName: 'Test',
        quizCategory: 'Art',
        quizDescription: 'Random',
        quizMark: 2,
        quizDateCreated: '2023-03-31 20:28',
        quizQuestions: [
          Question(
              questionNumber: 1,
              questionText: 'questionText1',
              questionAnswer: 'questionAnswer1',
              questionMark: 2),
          Question(
              questionNumber: 2,
              questionText: 'questionText2',
              questionAnswer: 'questionAnswer2',
              questionMark: 3),
        ],
        quizID: '10000',
        quizAuthor: 'Kg');
    Quiz? quizOutput = await service.addQuizWithQuestions(quiz);
    expect(quizOutput?.quizID, quiz.quizID);
  });

  test('get user and past attempts', () async {
    final service = MockDataService();
    String UserId = "id";
    final UserData? userData =
        await service.getUserAndPastAttempts(userID: UserId);

    expect(userData?.firstName, "Test");
  });
}
