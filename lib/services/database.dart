import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kwiz_v2/models/bookmarks.dart';
import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/models/user.dart';
import '../models/questions.dart';
import '../models/quizzes.dart';

class DatabaseService {
  //Quiz Collection Name
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection('Quizzes');

  //Category Colection Name
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('Categories');

  //User Colection Name
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //add quiz
  //This method adds a 'quiz' to the Quiz-Collection and adds a list of 'questions' in a Sub-Collection(called Questions) of the added 'quiz'
  Future<void> addQuizWithQuestions(Quiz quizInstance) async {
    //the var result returns the quiz object that has just been added to the database
    var result = await quizCollection.add({
      'QuizName': quizInstance.quizName,
      'QuizCategory': quizInstance.quizCategory,
      'QuizDescription': quizInstance.quizDescription,
      // 'QuizMark': QuizInstance.QuizMark,
      'QuizDateCreated': quizInstance.quizDateCreated,
    });

    //this uses the quiz ID and adds each question to a SUb Collection
    String quizId = result.id;
    quizInstance.quizQuestions.forEach((question) async {
      await _addQuestionDocument(quizID: quizId, question: question);
    });
  }

  //add question
  //This private method is called by the addQuizWithQuestions method and adds one question to the database at a time
  Future<void> _addQuestionDocument(
      {String? quizID, Question? question}) async {
    quizCollection.doc(quizID).collection('Questions').add({
      'QuestionAnswer': question!.questionAnswer,
      // 'QuestionMark': Question!.QuestionMark,
      'QuestionNumber': question.questionNumber,
      'QuestionText': question.questionText,
    });
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get Categories
  //This method gets the one and only document from the Category collection and returns the items stored in the docs array as a list
  Future<List?> getCategories() async {
    // Get doc from Category collection
    DocumentSnapshot docSnapshot =
        await categoryCollection.doc('gbdJOUgd8F5z26sKfjxu').get();

    // Get data from doc and return as array
    final categoryList = docSnapshot['CategoryName'];
    return categoryList;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get all Quiz Info only
  //This method gets the selected quiz from the Quiz Collection and its information
  // Future<Quiz?> getQuizInformationOnly({String? QuizID}) async {
  //   late List<Question> questions = [];
  //   DocumentSnapshot docSnapshot = await quizCollection.doc(QuizID).get();

  //   Quiz quiz = Quiz(
  //       QuizName: docSnapshot['QuizName'],
  //       QuizCategory: docSnapshot['QuizCategory'],
  //       QuizDescription: docSnapshot['QuizDescription'],
  //       QuizMark: 0,
  //       QuizDateCreated: docSnapshot['QuizDateCreated'],
  //       QuizQuestions: questions,
  //       QuizID: docSnapshot.id);

  //   return quiz;
  // }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get all Quizzes
  //This method gets all the quizzes from the Quiz Collection and retruns them as a list of Quiz objects
  Future<List<Quiz>?> getAllQuizzes() async {
    List<Quiz> quizzes = [];
    //gets all docs from collection
    QuerySnapshot collectionSnapshot = await quizCollection.get();
    //loops through each document and creates quiz object and adds to quiz list
    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      late List<Question> questions = [];
      Quiz quiz = Quiz(
          quizName: docSnapshot['QuizName'],
          quizCategory: docSnapshot['QuizCategory'],
          quizDescription: docSnapshot['QuizDescription'],
          // QuizMark: docSnapshot['QuizMark'],
          quizMark: 0,
          quizDateCreated: docSnapshot['QuizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id);
      quizzes.add(quiz);
    }
    return quizzes;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get all Quiz and Questions
  //This method gets the selected quiz from the Quiz Collection and its subcollection of questions and retruns a quiz object with a list of ordered questions
  Future<Quiz?> getQuizAndQuestions({String? quizID}) async {
    late List<Question> questions = [];

    try {
      DocumentSnapshot docSnapshot = await quizCollection.doc(quizID).get();
      Quiz quiz = Quiz(
          quizName: docSnapshot['QuizName'],
          quizCategory: docSnapshot['QuizCategory'],
          quizDescription: docSnapshot['QuizDescription'],
          quizMark: 0,
          quizDateCreated: docSnapshot['QuizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id);

      QuerySnapshot collectionSnapshot =
          await quizCollection.doc(quizID).collection('Questions').get();
      for (int i = 0; i < collectionSnapshot.docs.length; i++) {
        var docSnapshot = collectionSnapshot.docs[i];
        Question question = Question(
            questionNumber: docSnapshot['QuestionNumber'],
            questionText: docSnapshot['QuestionText'],
            questionAnswer: docSnapshot['QuestionAnswer'],
            questionMark: 0);

        questions.add(question);
      }

      quiz.quizQuestions
          .sort((a, b) => a.questionNumber.compareTo(b.questionNumber));

      return quiz;
    } catch (e) {
      if (kDebugMode) {
        print("Error!!!!! - $e");
      }
    }
    return null;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get Quiz based on category
  //This method gets quizzes from the Quiz Collection based on its category
  Future<List<Quiz>?> getQuizByCategory({String? category}) async {
    List<Quiz> quizzes = [];
    //exacutes a query based on field value
    Query<Object?> collectionQuery =
        quizCollection.where('QuizCategory', isEqualTo: category);

    //converts query to snapshot
    QuerySnapshot collectionSnapshot = await collectionQuery.get();

    //loops through each document and creates quiz object and adds to quiz list
    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];
      late List<Question> questions = [];
      Quiz quiz = Quiz(
          quizName: docSnapshot['QuizName'],
          quizCategory: docSnapshot['QuizCategory'],
          quizDescription: docSnapshot['QuizDescription'],
          quizMark: 0,
          quizDateCreated: docSnapshot['QuizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id);
      quizzes.add(quiz);
    }
    return quizzes;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get all Quiz Info only
  //This method gets the selected quiz from the Quiz Collection and its information
  Future<Quiz?> getQuizInformationOnly({String? quizID}) async {
    late List<Question> questions = [];
    DocumentSnapshot docSnapshot = await quizCollection.doc(quizID).get();

    Quiz quiz = Quiz(
        quizName: docSnapshot['QuizName'],
        quizCategory: docSnapshot['QuizCategory'],
        quizDescription: docSnapshot['QuizDescription'],
        quizMark: 0,
        quizDateCreated: docSnapshot['QuizDateCreated'],
        quizQuestions: questions,
        quizID: docSnapshot.id);

    return quiz;
  }

  //---------------------------------
  Future<UserData?> getUserAndPastAttempts({String? userID}) async {
    //Past aatempt cpuld change to user
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];

    try {
      DocumentSnapshot docSnapshot = await userCollection.doc(userID).get();
      UserData user = UserData(
          //uid: docSnapshot['QuizName'],
          userName: docSnapshot['userName'],
          firstName: docSnapshot['firstName'],
          lastName: docSnapshot['lastName'],
          bookmarkedQuizzes: bookmarks,
          pastAttemptQuizzes: pastAttempts,
          uID: docSnapshot.id);

      QuerySnapshot collectionSnapshot =
          await userCollection.doc(userID).collection('Past Attempts').get();
      for (int i = 0; i < collectionSnapshot.docs.length; i++) {
        var docSnapshot = collectionSnapshot.docs[i];
        List<String> pastAttemptQuizDatesAttempted =
            List<String>.from(docSnapshot['pastAttemptQuizDatesAttempted']);
        List<int> pastAttemptQuizMarks =
            List<int>.from(docSnapshot['pastAttemptQuizMarks']);
        PastAttempt pastAttempt = PastAttempt(
            quizID: docSnapshot['quizID'],
            pastAttemptQuizName: docSnapshot['pastAttemptQuizName'],
            pastAttemptQuizCategory: docSnapshot['pastAttemptQuizCategory'],
            pastAttemptQuizDescription:
                docSnapshot['pastAttemptQuizDescription'],
            pastAttemptQuizDateCreated:
                docSnapshot['pastAttemptQuizDateCreated'],
            pastAttemptQuizMark: docSnapshot['pastAttemptQuizMark'],
            pastAttemptQuizMarks: pastAttemptQuizMarks,
            pastAttemptQuizDatesAttempted: pastAttemptQuizDatesAttempted);

        pastAttempts.add(pastAttempt);
      }

      // user.pastAttemptQuizzes
      //     .sort((a, b) => a.pastAttemptQuizDatesAttempted[].compareTo(b.questionNumber));

      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Error!!!!! - $e");
      }
    }
    return null;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------
  //streams
  //get quiz stream

  Future<void> addUser(UserData userInstance, OurUser ourUserInstance) async {
    //the var result returns the quiz object that has just been added to the database
    var result = await userCollection.doc(ourUserInstance.uid).set({
      'FirstName': userInstance.firstName,
      'LastName': userInstance.lastName,
      'Username': userInstance.userName,
    });
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------
}
