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
  Future<void> _addQuestionDocument(
      {String? quizID, Question? question}) async {
    // QuizCollection.doc(quizID).collection('Questions').add({
    //   'QuestionAnswer': question!.questionAnswer,
    // // 'QuestionMark': Question!.QuestionMark,
    // 'QuestionNumber': question.questionNumber,
    // 'QuestionText': question.questionText,
    // });
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection(QuizCollection)
        .doc(quizID)
        .collection('Questions')
        .doc()
        .set({
      'QuestionAnswer': question!.questionAnswer,
      // 'QuestionMark': Question!.QuestionMark,
      'QuestionNumber': question.questionNumber,
      'QuestionText': question.questionText,
    });
  }

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
  Future<Quiz?> addQuizWithQuestions(Quiz quizInstance) async {
    final firestore = FakeFirebaseFirestore();
    late List<Question> questions = [];
    await firestore.collection(QuizCollection).doc(quizInstance.quizID).set({
      'quizName': quizInstance.quizName,
      'quizAuthor': quizInstance.quizName,
      'quizCategory': quizInstance.quizName,
      'quizDescription': quizInstance.quizName,
      'quizMark': quizInstance.quizName,
      'quizDateCreated': quizInstance.quizDateCreated,
      'quizID': quizInstance.quizName,
      'quizQuestions': questions,
    });

    quizInstance.quizQuestions.forEach((question) async {
      await _addQuestionDocument(
          quizID: quizInstance.quizID, question: question);
    });

    DocumentSnapshot docSnapshot = await firestore
        .collection(QuizCollection)
        .doc(quizInstance.quizID)
        .get();

    QuerySnapshot collectionSnapshot = await firestore
        .collection(QuizCollection)
        .doc(quizInstance.quizID)
        .collection('Questions')
        .get();

    List<Question> questionsOutput = [];

    Quiz quizOutput = Quiz(
        quizName: docSnapshot['quizName'],
        quizCategory: docSnapshot['quizCategory'],
        quizDescription: docSnapshot['quizDescription'],
        quizMark: 0,
        quizDateCreated: docSnapshot['quizDateCreated'],
        quizQuestions: questions,
        quizID: docSnapshot.id,
        quizAuthor: docSnapshot['quizAuthor']);

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Question question = Question(
          questionNumber: docSnapshot['QuestionNumber'],
          questionText: docSnapshot['QuestionText'],
          questionAnswer: docSnapshot['QuestionAnswer'],
          questionMark: 0,
          questionType: "shortAnswer");

      questions.add(question);
    }

    return quizOutput;
  }

  @override
  Future<Quiz?> getQuizAndQuestions({String? quizID}) async {
    final firestore = FakeFirebaseFirestore();
    late List<Question> questions = [];

    await firestore.collection(QuizCollection).doc(quizID).set({
      'quizName': 'Biology Quiz',
      'quizAuthor': 'Biology Quiz Author',
      'quizCategory': 'Biology',
      'quizDescription': 'Quiz about Biology',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
    });

    await firestore
        .collection(QuizCollection)
        .doc(quizID)
        .collection('Questions')
        .doc('id')
        .set({
      'QuestionAnswer': "Leonardo da Vinci",
      'QuestionNumber': 1,
      'QuestionText': "Who painted the Mona Lisa",
    });

    DocumentSnapshot docSnapshot =
        await firestore.collection(QuizCollection).doc(quizID).get();

    QuerySnapshot collectionSnapshot = await firestore
        .collection(QuizCollection)
        .doc(quizID)
        .collection('Questions')
        .get();

    List<Question> questionsOutput = [];

    Quiz quizOutput = Quiz(
        quizName: docSnapshot['quizName'],
        quizCategory: docSnapshot['quizCategory'],
        quizDescription: docSnapshot['quizDescription'],
        quizMark: 0,
        quizDateCreated: docSnapshot['quizDateCreated'],
        quizQuestions: questions,
        quizID: docSnapshot.id,
        quizAuthor: docSnapshot['quizAuthor']);

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Question question = Question(
          questionNumber: docSnapshot['QuestionNumber'],
          questionText: docSnapshot['QuestionText'],
          questionAnswer: docSnapshot['QuestionAnswer'],
          questionMark: 0,
          questionType: "shortAnswer");

      questions.add(question);
    }

    return quizOutput;
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
        pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted,
      );
      pastAttempts.add(pastAttempt);
    }

    return user;
  }

  @override
  Future<UserData?> getUserAndBookmarks({String? userID}) async {
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
        .collection('Bookmarks')
        .doc('id')
        .set({
      'QuizID': "id",
      'BookmarkQuizName': "Quiz Test",
      'BookmarkQuizAuthor': "Tester",
      'BookmarkQuizCategory': "Test Category",
      'BookmarkQuizDescription': "Test Description",
      'BookmarkQuizDateCreated': "Test Date",
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

    await firestore.collection(UserCollection).doc(userID).set({
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

    await firestore.collection(UserCollection).doc(userID).set({
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
      'BookmarkQuizDateCreated': "Test Date",
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

    await firestore.collection(UserCollection).doc(uid).set({
      'FirstName': "Test",
      'LastName': "Dummy",
      'Username': "TestDummy",
    });

    DocumentSnapshot docSnapshot =
        await firestore.collection(UserCollection).doc(uid).get();

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
  Future<UserData?> addUser(
      UserData userInstance, OurUser ourUserInstance) async {
    final firestore = FakeFirebaseFirestore();
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    await firestore.collection(UserCollection).doc(ourUserInstance.uid).set({
      'FirstName': userInstance.firstName,
      'LastName': userInstance.lastName,
      'Username': userInstance.userName,
    });

    DocumentSnapshot docSnapshot = await firestore
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

  @override
  Future<List<Quiz>?> getAllQuizzes() async {
    final firestore = FakeFirebaseFirestore();
    late List<Question> questions = [];

    await firestore.collection(QuizCollection).doc("quizid").set({
      'quizName': 'Biology Quiz',
      'quizAuthor': 'Biology Quiz Author',
      'quizCategory': 'Biology',
      'quizDescription': 'Quiz about Biology',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
      'quizQuestions': questions
    });
    await firestore.collection(QuizCollection).doc("quizid2").set({
      'quizName': 'Biology Quiz 2',
      'quizAuthor': 'Biology Quiz Author 2',
      'quizCategory': 'Biology 2',
      'quizDescription': 'Quiz about Biology 2',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
      'quizQuestions': questions
    });
    List<Quiz> quizzes = [];

    QuerySnapshot collectionSnapshot =
        await firestore.collection(QuizCollection).get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      late List<Question> questions = [];
      Quiz quiz = Quiz(
          quizName: docSnapshot['quizName'],
          quizCategory: docSnapshot['quizCategory'],
          quizDescription: docSnapshot['quizDescription'],
          quizMark: docSnapshot['quizMark'],
          quizDateCreated: docSnapshot['quizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id,
          quizAuthor: docSnapshot['quizAuthor']);
      quizzes.add(quiz);
    }
    return quizzes;
  }

  @override
  Future<List<Quiz>?> getQuizByCategory({String? category}) async {
    final firestore = FakeFirebaseFirestore();
    late List<Question> questions = [];

    await firestore.collection(QuizCollection).doc("quizid").set({
      'quizName': 'Biology Quiz',
      'quizAuthor': 'Biology Quiz Author',
      'quizCategory': 'Biology',
      'quizDescription': 'Quiz about Biology',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
      'quizQuestions': questions
    });
    await firestore.collection(QuizCollection).doc("quizid2").set({
      'quizName': 'Biology Quiz 2',
      'quizAuthor': 'Biology Quiz Author 2',
      'quizCategory': 'Biology',
      'quizDescription': 'Quiz about Biology 2',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
      'quizQuestions': questions
    });
    await firestore.collection(QuizCollection).doc("quizid3").set({
      'quizName': 'Sport Quiz',
      'quizAuthor': 'Sport Quiz Author',
      'quizCategory': 'Sport',
      'quizDescription': 'Quiz about Sport',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
      'quizQuestions': questions
    });
    List<Quiz> quizzes = [];

    QuerySnapshot collectionSnapshot = await firestore
        .collection(QuizCollection)
        .where('quizCategory', isEqualTo: category)
        .get();

    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      Quiz quiz = Quiz(
          quizName: docSnapshot['quizName'],
          quizCategory: docSnapshot['quizCategory'],
          quizDescription: docSnapshot['quizDescription'],
          quizMark: docSnapshot['quizMark'],
          quizDateCreated: docSnapshot['quizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id,
          quizAuthor: docSnapshot['quizAuthor']);
      quizzes.add(quiz);
    }
    return quizzes;
  }

  @override
  Future<Quiz?> getQuizInformationOnly({String? quizID}) async {
    final firestore = FakeFirebaseFirestore();
    late List<Question> questions = [];

    await firestore.collection(QuizCollection).doc(quizID).set({
      'quizName': 'Biology Quiz',
      'quizAuthor': 'Biology Quiz Author',
      'quizCategory': 'Biology',
      'quizDescription': 'Quiz about Biology',
      'quizMark': 10,
      'quizDateCreated': '2023-03-31 20:28',
    });

    DocumentSnapshot docSnapshot =
        await firestore.collection(QuizCollection).doc(quizID).get();

    Quiz quiz = Quiz(
        quizName: docSnapshot['quizName'],
        quizCategory: docSnapshot['quizCategory'],
        quizDescription: docSnapshot['quizDescription'],
        quizMark: docSnapshot['quizMark'],
        quizDateCreated: docSnapshot['quizDateCreated'],
        quizQuestions: questions,
        quizID: docSnapshot.id,
        quizAuthor: docSnapshot['quizAuthor']);

    return quiz;
  }

  Future<PastAttempt> createPastAttempt(
      {String? userID,
      Quiz? quiz,
      int? quizMark,
      String? quizDateAttempted,
      required String quizAuthor}) async {
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
      'quizID': quiz?.quizID,
      'pastAttemptQuizName': quiz?.quizID,
      'pastAttemptQuizAuthor': quiz?.quizAuthor,
      'pastAttemptQuizCategory': quiz?.quizCategory,
      'pastAttemptQuizDescription': quiz?.quizDescription,
      'pastAttemptQuizDateCreated': quiz?.quizDateCreated,
      'pastAttemptQuizMark': quiz?.quizMark,
      'pastAttemptQuizMarks': [quizMark],
      'pastAttemptQuizDatesAttempted': [quizDateAttempted]
    });

    DocumentSnapshot docSnapshot = await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Past Attempts')
        .doc('id')
        .get();
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
      pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted,
    );

    return pastAttempt;
  }

  Future<PastAttempt> addPastAttempt(
      {String? userID,
      List<int>? quizMarks,
      String? quizDateAttempted,
      String? quizID}) async {
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
        .doc(quizID)
        .set({
      'quizID': quizID,
      'pastAttemptQuizName': 'Biology Quiz',
      'pastAttemptQuizAuthor': 'Biology Quiz Author',
      'pastAttemptQuizCategory': 'Biology',
      'pastAttemptQuizDescription': 'Quiz about Biology',
      'pastAttemptQuizDateCreated': '2023-03-31 20:28',
      'pastAttemptQuizMark': 10,
      'pastAttemptQuizMarks': quizMarks,
      'pastAttemptQuizDatesAttempted': ['2023-03-31 20:28']
    });

    await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Past Attempts')
        .doc(quizID)
        .update({
      //PROBLEM: doc(quizID) wont work. Docs not the same id
      'pastAttemptQuizMarks': quizMarks,
      'pastAttemptQuizDatesAttempted':
          FieldValue.arrayUnion([quizDateAttempted]),
    });

    DocumentSnapshot docSnapshot = await firestore
        .collection(UserCollection)
        .doc(userID)
        .collection('Past Attempts')
        .doc(quizID)
        .get();
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
      pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted,
    );

    return pastAttempt;
  }
}
