import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/quizzes.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/take_quiz.dart';
import 'package:kwiz_v2/services/database.dart';

void main() {
  test('description', () => expect(1, 1));
  group('Take quiz', () {
    test('Populate questions', () {
      DatabaseService service = DatabaseService();
      final QuizScreenWidget = QuizScreenState();
      QuizScreenWidget.service = service;
      List<Question> quizQuestions = [
        Question(
          questionNumber: 1,
          questionText: "What is the capital of France?",
          questionAnswer: "Paris",
          questionMark: 5,
        ),
        Question(
          questionNumber: 2,
          questionText: "What is the tallest mountain in the world?",
          questionAnswer: "Mount Everest",
          questionMark: 10,
        ),
        Question(
          questionNumber: 3,
          questionText: "What is the largest continent?",
          questionAnswer: "Asia",
          questionMark: 5,
        ),
      ];
      Quiz quiz = Quiz(
        quizName: "Math Quiz",
        quizCategory: "Mathematics",
        quizDescription: "Test your math skills with this quiz!",
        quizMark: 20,
        quizDateCreated: "2022-05-01",
        quizQuestions: quizQuestions,
        quizID: "1234",
        quizAuthor: "John Doe",
      );

      expect(QuizScreenWidget.popQuestionsList(quiz, [], []), [
        "What is the capital of France?",
        "What is the tallest mountain in the world?",
        "What is the largest continent?"
      ]);
    });

    test('Populate answers', () {
      final QuizScreenWidget = QuizScreenState();
      DatabaseService service = DatabaseService();
      QuizScreenWidget.service = service;
      List<Question> quizQuestions = [
        Question(
          questionNumber: 1,
          questionText: "What is the capital of France?",
          questionAnswer: "Paris",
          questionMark: 5,
        ),
        Question(
          questionNumber: 2,
          questionText: "What is the tallest mountain in the world?",
          questionAnswer: "Mount Everest",
          questionMark: 10,
        ),
        Question(
          questionNumber: 3,
          questionText: "What is the largest continent?",
          questionAnswer: "Asia",
          questionMark: 5,
        ),
      ];
      Quiz quiz = Quiz(
        quizName: "Math Quiz",
        quizCategory: "Mathematics",
        quizDescription: "Test your math skills with this quiz!",
        quizMark: 20,
        quizDateCreated: "2022-05-01",
        quizQuestions: quizQuestions,
        quizID: "1234",
        quizAuthor: "John Doe",
      );

      expect(QuizScreenWidget.popAnswersList(quiz, [], []),
          ["Paris", "Mount Everest", "Asia"]);
    });
  });
}
