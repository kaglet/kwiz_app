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
  test('get user and past attempts', () async {
    final service = MockDataService();
    String UserId = "Userid";
    final UserData? userData = await service.getUserAndPastAttempts(userID: UserId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.pastAttemptQuizzes[0].quizID, "id");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizName, "Quiz Test");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizAuthor, "Tester");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizCategory, "Test Category");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDescription, "Test Description");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDateCreated, "Test Date");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizMark, 2);
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizMarks, [1,2]);
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDatesAttempted, ["Test Date 1", "Test Date 2"]);
  });
  test('get user and bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    final UserData? userData = await service.getUserAndBookmarks(userID: UserId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes[0].quizID, "id");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizName, "Quiz Test");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizAuthor, "Tester");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizCategory, "Test Category");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDescription, "Test Description");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDateCreated, "Test Date");
  });
  test('add bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    Quiz quizTest = Quiz(
      quizName: "Quiz Test", 
      quizCategory: "Test Category", 
      quizDescription: "Test Description", 
      quizMark: 0, 
      quizDateCreated: "Test Date", 
      quizQuestions: [], 
      quizID: "id", 
      quizAuthor: "Tester");

    final UserData? userData = await service.addBookmarks(userID: UserId, quiz: quizTest);

    expect(userData?.bookmarkedQuizzes[0].quizID, "id");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizName, "Quiz Test");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizAuthor, "Tester");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizCategory, "Test Category");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDescription, "Test Description");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDateCreated, "Test Date");
  });
  test('delete bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    String QuizId = "Quizid";

    final UserData? userData = await service.deleteBookmarks(userID: UserId, quizID: QuizId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
  test('get user', () async {
    final service = MockDataService();
    String uid = "uid";
  
    final UserData? userData = await service.getUser(uid);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
  test('add user', () async {
    final service = MockDataService();
    OurUser ourUser = OurUser(uid:  "uid");
    UserData userDataIn = UserData(
      uID: "", 
      userName: "TestDummy", 
      firstName: "Test", 
      lastName: "Dummy", 
      bookmarkedQuizzes: [], 
      pastAttemptQuizzes: []);
  
    final UserData? userData = await service.addUser(userDataIn, ourUser);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
}
