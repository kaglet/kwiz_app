// coverage:ignore-start
import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/quizzes.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';
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
          questionMark: 0);

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
          questionMark: 0);

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
          pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted);
      pastAttempts.add(pastAttempt);
    }

    return user;
  }
}
// coverage:ignore-end