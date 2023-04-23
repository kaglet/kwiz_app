// coverage:ignore-start
import 'dart:math';

import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/quizzes.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';
import '../models/quizzes.dart';
import '../models/user.dart';

const CategoryCollection = 'categories';
const UserCollection = 'users';
const QuizCollection = 'quizzes';

class MockDataService extends Mock implements DatabaseService {
  @override
  Future<List?> getCategories() async {
    final firestore = FakeFirebaseFirestore();
    late List? categories = ['Art', 'Science'];
    late List? testCategories = [];
    await firestore
        .collection(CategoryCollection)
        .doc('gbdJOUgd8F5z26sKfjxu')
        .set({
      'CategoryName': categories,
    });
    // Get doc from Category collection
    DocumentSnapshot docSnapshot = await firestore
        .collection(CategoryCollection)
        .doc('gbdJOUgd8F5z26sKfjxu')
        .get();

    // Get data from doc and return as array
    testCategories = docSnapshot['CategoryName'];

    return (categories);
  }

  @override
  Future<UserData?> getUserAndPastAttempts({String? userID}) async {
    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore.collection(UserCollection).doc(userID).set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

    await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Past Attempts')
        .doc('id')
        .set({
      'quizID': "id",
      'pastAttemptQuizName': "Quiz Test",
      'pastAttemptQuizAuthor': "Tester",
      'pastAttemptQuizCategory': "Test Category",
      'pastAttemptQuizDescription': "Test Description",
      'pastAttemptQuizDateCreated': "Test Date",
      'pastAttemptQuizMark': 2,
      'pastAttemptQuizMarks': [1, 2],
      'pastAttemptQuizDatesAttempted': ["Test Date 1", "Test Date 2"]
    });

    DocumentSnapshot docSnapshot =
        await firestore.collection(UserCollection).doc(userID).get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    QuerySnapshot collectionSnapshot = await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Past Attempts')
        .get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      List<String> pastAttemptQuizDatesAttempted =
          List<String>.from(docSnapshot['pastAttemptQuizDatesAttempted']);
      List<int> pastAttemptQuizMarks =
          List<int>.from(docSnapshot['pastAttemptQuizMarks']);
      PastAttempt pastAttempt = PastAttempt(
          quizID: docSnapshot['quizID'],
          pastAttemptQuizAuthor: docSnapshot['pastAttemptQuizAuthor'],
          pastAttemptQuizName: docSnapshot['pastAttemptQuizName'],
          pastAttemptQuizCategory: docSnapshot['pastAttemptQuizCategory'],
          pastAttemptQuizDescription: docSnapshot['pastAttemptQuizDescription'],
          pastAttemptQuizDateCreated: docSnapshot['pastAttemptQuizDateCreated'],
          pastAttemptQuizMark: docSnapshot['pastAttemptQuizMark'],
          pastAttemptQuizMarks: pastAttemptQuizMarks,
          pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted);
      pastAttempts.add(pastAttempt);
    }

    return user;
  }

  @override
  Future<UserData?> getUserAndBookmarks({String? userID}) async {
    
    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore
        .collection(UserCollection)
        .doc(userID)
        .set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

    await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .doc('id')
      .set({
      'QuizID': "id",
      'BookmarkQuizName': "Quiz Test",
      'BookmarkQuizAuthor': "Tester",
      'BookmarkQuizCategory': "Test Category",
      'BookmarkQuizDescription': "Test Description",
      'BookmarkQuizDateCreated':  "Test Date",
    });

    DocumentSnapshot docSnapshot = await  firestore
      .collection(UserCollection)
      .doc(userID)
      .get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    QuerySnapshot collectionSnapshot = await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Bookmarks bookmark = Bookmarks(
          quizID: docSnapshot['QuizID'],
          bookmarkQuizName: docSnapshot['BookmarkQuizName'],
          bookmarkQuizAuthor: docSnapshot['BookmarkQuizAuthor'],
          bookmarkQuizDescription: docSnapshot['BookmarkQuizDescription'],
          bookmarkQuizCategory: docSnapshot['BookmarkQuizCategory'],
          bookmarkQuizDateCreated: docSnapshot['BookmarkQuizDateCreated']);

      bookmarks.add(bookmark);
    }

    return user;
  }

  @override
  Future<UserData?> addBookmarks({String? userID, Quiz? quiz}) async {
    
    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore
        .collection(UserCollection)
        .doc(userID)
        .set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

    await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .doc('id')
      .set({
      'QuizID': quiz!.quizID,
      'BookmarkQuizName': quiz.quizName,
      'BookmarkQuizAuthor': quiz.quizAuthor,
      // 'QuestionMark': Question!.QuestionMark,
      'BookmarkQuizCategory': quiz.quizCategory,
      'BookmarkQuizDescription': quiz.quizDescription,
      'BookmarkQuizDateCreated': quiz.quizDateCreated,
    });

    DocumentSnapshot docSnapshot = await  firestore
      .collection(UserCollection)
      .doc(userID)
      .get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    QuerySnapshot collectionSnapshot = await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Bookmarks bookmark = Bookmarks(
          quizID: docSnapshot['QuizID'],
          bookmarkQuizName: docSnapshot['BookmarkQuizName'],
          bookmarkQuizAuthor: docSnapshot['BookmarkQuizAuthor'],
          bookmarkQuizDescription: docSnapshot['BookmarkQuizDescription'],
          bookmarkQuizCategory: docSnapshot['BookmarkQuizCategory'],
          bookmarkQuizDateCreated: docSnapshot['BookmarkQuizDateCreated']);

      bookmarks.add(bookmark);
    }

    return user;
  }

  @override
  Future<UserData?> deleteBookmarks({String? userID, String? quizID}) async {
    
    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore
        .collection(UserCollection)
        .doc(userID)
        .set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

    await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .doc(quizID)
      .set({
      'QuizID': quizID,
      'BookmarkQuizName': "Quiz Test",
      'BookmarkQuizAuthor': "Tester",
      'BookmarkQuizCategory': "Test Category",
      'BookmarkQuizDescription': "Test Description",
      'BookmarkQuizDateCreated':  "Test Date",
    });

    QuerySnapshot querySnapshot = await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Bookmarks')
        .where('QuizID', isEqualTo: quizID)
        .get();

    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });

    DocumentSnapshot docSnapshot = await  firestore
      .collection(UserCollection)
      .doc(userID)
      .get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    QuerySnapshot collectionSnapshot = await firestore
      .collection(UserCollection)
      .doc(userID)
      .collection('Bookmarks')
      .get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Bookmarks bookmark = Bookmarks(
          quizID: docSnapshot['QuizID'],
          bookmarkQuizName: docSnapshot['BookmarkQuizName'],
          bookmarkQuizAuthor: docSnapshot['BookmarkQuizAuthor'],
          bookmarkQuizDescription: docSnapshot['BookmarkQuizDescription'],
          bookmarkQuizCategory: docSnapshot['BookmarkQuizCategory'],
          bookmarkQuizDateCreated: docSnapshot['BookmarkQuizDateCreated']);

      bookmarks.add(bookmark);
    }

    return user;   
  }

  @override
  Future<UserData?> getUser(String? uid) async {

    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore
      .collection(UserCollection)
      .doc(uid)
      .set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

     DocumentSnapshot docSnapshot = await  firestore
      .collection(UserCollection)
      .doc(uid)
      .get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    return user;
  }
  
  @override
  Future<UserData?> addUser(UserData userInstance, OurUser ourUserInstance) async {

    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore
      .collection(UserCollection)
      .doc(ourUserInstance.uid)
      .set({
      'FirstName': userInstance.firstName,
      'LastName': userInstance.lastName,
      'Username': userInstance.userName,
    });

     DocumentSnapshot docSnapshot = await  firestore
      .collection(UserCollection)
      .doc(ourUserInstance.uid)
      .get();

    UserData user = UserData(
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        bookmarkedQuizzes: bookmarks,
        pastAttemptQuizzes: pastAttempts,
        uID: docSnapshot.id);

    return user;
  }
}
// coverage:ignore-end