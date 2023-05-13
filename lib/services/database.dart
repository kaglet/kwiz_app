import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kwiz_v2/models/bookmarks.dart';
import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/models/user.dart';
import '../models/questions.dart';
import '../models/quizzes.dart';
import '../models/rating.dart';

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
      'QuizAuthor': quizInstance.quizAuthor,
      'QuizGlobalRating': quizInstance.quizGlobalRating,
      'QuizTotalRatings': quizInstance.quizTotalRatings
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
    if (question is MultipleAnswerQuestion) {
      quizCollection.doc(quizID).collection('Questions').add({
        'QuestionAnswer': question!.questionAnswer,
        // 'QuestionMark': Question!.QuestionMark,
        'QuestionNumber': question.questionNumber,
        'QuestionText': question.questionText,
        'QuestionType': question.questionType,
        'QuestionAnswerOptions': question.answerOptions,
      });
    } else {
      quizCollection.doc(quizID).collection('Questions').add({
        'QuestionAnswer': question!.questionAnswer,
        // 'QuestionMark': Question!.QuestionMark,
        'QuestionNumber': question.questionNumber,
        'QuestionText': question.questionText,
        'QuestionType': question.questionType,
      });
    }
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
      DocumentSnapshot docSnapshot = collectionSnapshot.docs[i];
      late List<Question> questions = [];
      Quiz quiz = Quiz(
          quizName: docSnapshot['QuizName'],
          quizCategory: docSnapshot['QuizCategory'],
          quizDescription: docSnapshot['QuizDescription'],
          // QuizMark: docSnapshot['QuizMark'],
          quizMark: 0,
          quizDateCreated: docSnapshot['QuizDateCreated'],
          quizQuestions: questions,
          quizID: docSnapshot.id,
          quizGlobalRating: docSnapshot['QuizGlobalRating'],
          quizTotalRatings: docSnapshot['QuizTotalRatings'],
          quizAuthor: docSnapshot['QuizAuthor']);
      quizzes.add(quiz);
    }
    return quizzes;
  }

  //--------------------------
  //
  ////-----------------------------------------------------------------------------------------------------------------------------------------------------
  //get all Quizzes
  //This method gets all the quizzes from the Quiz Collection and retruns them as a list of Quiz objects
  Future<List<UserData>?> getAllUsers() async {
    List<UserData> users = [];
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];
    late List<Rating> ratings = [];
    //gets all docs from collection
    QuerySnapshot collectionSnapshot = await userCollection.get();

    //loops through each document and creates quiz object and adds to quiz list
    for (int i = 0; i < collectionSnapshot.docs.length; i++) {
      var docSnapshot = collectionSnapshot.docs[i];

      UserData user = UserData(
          //uid: docSnapshot['QuizName'],
          userName: docSnapshot['Username'],
          firstName: docSnapshot['FirstName'],
          lastName: docSnapshot['LastName'],
          totalScore: docSnapshot['TotalScore'],
          totalQuizzes: docSnapshot['TotalQuizzes'],
          bookmarkedQuizzes: bookmarks,
          pastAttemptQuizzes: pastAttempts,
          ratings: ratings,
          uID: docSnapshot.id);

      users.add(user);
    }

    return users;
  }
  //-------------------------------------------------------------------------------------------------------------------------------

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
          quizID: docSnapshot.id,
          quizGlobalRating: docSnapshot['QuizGlobalRating'],
          quizTotalRatings: docSnapshot['QuizTotalRatings'],
          quizAuthor: docSnapshot['QuizAuthor']);

      QuerySnapshot collectionSnapshot =
          await quizCollection.doc(quizID).collection('Questions').get();
      for (int i = 0; i < collectionSnapshot.docs.length; i++) {
        var docSnapshot = collectionSnapshot.docs[i];
        if (docSnapshot['QuestionType'] == "ranking" ||
            docSnapshot['QuestionType'] == "dropdown" ||
            docSnapshot['QuestionType'] == "multipleChoice") {
          List<String> QuestionAnswerOptions =
              List<String>.from(docSnapshot['QuestionAnswerOptions']);
          MultipleAnswerQuestion question = MultipleAnswerQuestion(
              questionNumber: docSnapshot['QuestionNumber'],
              questionText: docSnapshot['QuestionText'],
              questionAnswer: docSnapshot['QuestionAnswer'],
              questionMark: 0,
              questionType: docSnapshot['QuestionType'],
              answerOptions: QuestionAnswerOptions);
          questions.add(question);
        } else {
          Question question = Question(
              questionNumber: docSnapshot['QuestionNumber'],
              questionText: docSnapshot['QuestionText'],
              questionAnswer: docSnapshot['QuestionAnswer'],
              questionMark: 0,
              questionType: docSnapshot['QuestionType']);
          questions.add(question);
        }
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
          quizID: docSnapshot.id,
          quizGlobalRating: docSnapshot['QuizGlobalRating'],
          quizTotalRatings: docSnapshot['QuizTotalRatings'],
          quizAuthor: docSnapshot['QuizAuthor']);
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
        quizID: docSnapshot.id,
        quizGlobalRating: docSnapshot['QuizGlobalRating'],
        quizTotalRatings: docSnapshot['QuizTotalRatings'],
        quizAuthor: docSnapshot['QuizAuthor']);

    return quiz;
  }

  //---------------------------------
  Future<UserData?> getUserAndPastAttempts({String? userID}) async {
    //Past aatempt cpuld change to user
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];
    late List<Rating> ratings = [];

    try {
      DocumentSnapshot docSnapshot = await userCollection.doc(userID).get();
      UserData user = UserData(
          //uid: docSnapshot['QuizName'],
          userName: docSnapshot['Username'],
          firstName: docSnapshot['FirstName'],
          lastName: docSnapshot['LastName'],
          totalScore: docSnapshot['TotalScore'],
          totalQuizzes: docSnapshot['TotalQuizzes'],
          bookmarkedQuizzes: bookmarks,
          pastAttemptQuizzes: pastAttempts,
          ratings: ratings,
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

  //-------------------------------------------------------------------------------------------------

  Future<UserData?> getUserAndBookmarks({String? userID}) async {
    //Past aatempt cpuld change to user
    late List<PastAttempt> pastAttempts = [];
    late List<Bookmarks> bookmarks = [];
    late List<Rating> ratings = [];

    try {
      DocumentSnapshot docSnapshot = await userCollection.doc(userID).get();
      UserData user = UserData(
          //uid: docSnapshot['QuizName'],
          userName: docSnapshot['Username'],
          firstName: docSnapshot['FirstName'],
          lastName: docSnapshot['LastName'],
          totalScore: docSnapshot['TotalScore'],
          totalQuizzes: docSnapshot['TotalQuizzes'],
          bookmarkedQuizzes: bookmarks,
          pastAttemptQuizzes: pastAttempts,
          ratings: ratings,
          uID: docSnapshot.id);

      QuerySnapshot collectionSnapshot =
          await userCollection.doc(userID).collection('Bookmarks').get();
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

  //--------------------------------------------------------------------------------------------------

  Future<void> addBookmarks({String? userID, Quiz? quiz}) async {
    await userCollection.doc(userID).collection('Bookmarks').add({
      'QuizID': quiz!.quizID,
      'BookmarkQuizName': quiz.quizName,
      'BookmarkQuizAuthor': quiz.quizAuthor,
      // 'QuestionMark': Question!.QuestionMark,
      'BookmarkQuizCategory': quiz.quizCategory,
      'BookmarkQuizDescription': quiz.quizDescription,
      'BookmarkQuizDateCreated': quiz.quizDateCreated,
    });
  }

  Future<void> deleteBookmarks({String? userID, String? quizID}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .collection('Bookmarks')
          .where('QuizID', isEqualTo: quizID)
          .get();

      print(userID);
      if (querySnapshot.docs.isEmpty) {
        // Handle case where no documents match the query
        print('No documents match the query');
        return;
      }
      // Delete all documents that match the query
      querySnapshot.docs.forEach((document) {
        document.reference.delete();
      });

      print('Documents deleted successfully');
    } catch (error) {
      print('Failed to delete documents: $error');
    }
  }

  //--------------------------------------------------------------------------------------------------

  Future<void> createPastAttempt(
      {String? userID,
      Quiz? quiz,
      int? quizMark,
      String? quizDateAttempted,
      required String quizAuthor}) async {
    await userCollection
        .doc(userID)
        .collection('Past Attempts')
        .doc(quiz!.quizID)
        .set({
      'quizID': quiz.quizID,
      'pastAttemptQuizName': quiz.quizName,
      'pastAttemptQuizAuthor': quiz.quizAuthor,
      // 'QuestionMark': Question!.QuestionMark,
      'pastAttemptQuizCategory': quiz.quizCategory,
      'pastAttemptQuizDescription': quiz.quizDescription,
      'pastAttemptQuizDateCreated': quiz.quizDateCreated,
      'pastAttemptQuizMark': quiz.quizMark,
      'pastAttemptQuizMarks': [quizMark],
      'pastAttemptQuizDatesAttempted': [quizDateAttempted]
    });
  }

  //--------------------------------------------------------------------------------------------------

  Future<void> addPastAttempt(
      {String? userID,
      List<int>? quizMarks,
      String? quizDateAttempted,
      String? quizID}) async {
    await userCollection
        .doc(userID)
        .collection('Past Attempts')
        .doc(quizID)
        .update({
      //PROBLEM: doc(quizID) wont work. Docs not the same id
      'pastAttemptQuizMarks': quizMarks,
      'pastAttemptQuizDatesAttempted':
          FieldValue.arrayUnion([quizDateAttempted]),
    });
  }

  //--------------------------------------------------------------------------------------------------
  //This function gets a user and user information but fetches it with empty arrays for the bookmarks and past attempts
  //If need the bookmarks or past attempts use other appropriate functions
  Future<UserData?> getUser(String? uid) async {
    DocumentSnapshot docSnapshot = await userCollection.doc(uid).get();

    UserData user = UserData(
        uID: uid,
        userName: docSnapshot['Username'],
        firstName: docSnapshot['FirstName'],
        lastName: docSnapshot['LastName'],
        totalScore: docSnapshot['TotalScore'],
        totalQuizzes: docSnapshot['TotalQuizzes'],
        bookmarkedQuizzes: [],
        pastAttemptQuizzes: [],
        ratings: []);

    return user;
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
      'TotalScore': '0',
      'TotalQuizzes': 0,
    });
  }

//-----------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> updateUserScore(
      {String? userID, int? totalQuizzes, String? totalScore}) async {
    await userCollection.doc(userID).update({
      'TotalScore': totalScore,
      'TotalQuizzes': totalQuizzes,
    });
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------

  Future<void> createRating(
      {String? userID, String? quizID, int? rating}) async {
    await userCollection.doc(userID).collection('Ratings').doc(quizID).set({
      'Rating': rating,
    });
  }

  Future<void> updateRating(
      {String? userID, String? quizID, int? rating}) async {
    await userCollection.doc(userID).collection('Ratings').doc(quizID).update({
      'Rating': rating,
    });
  }

  Future<bool> ratingAlreadyExists({String? userID, String? quizID}) async {
    DocumentSnapshot docSnapshot = await userCollection
        .doc(userID)
        .collection('Ratings')
        .doc(quizID)
        .get();

    return docSnapshot.exists;
  }

  Future<void> addToQuizGlobalRating({String? quizID, int? rating}) async {
    DocumentSnapshot docQuizSnapshot = await quizCollection.doc(quizID).get();

    int quizGlobalRating = docQuizSnapshot['QuizGlobalRating'];
    int quizTotalRatings = docQuizSnapshot['QuizTotalRatings'];
    quizGlobalRating += rating!;
    quizTotalRatings++;

    await quizCollection.doc(quizID).update({
      'QuizGlobalRating': quizGlobalRating,
      'QuizTotalRatings': quizTotalRatings
    });
  }

  Future<int?> getOldRating({String? quizID, String? userID}) async {
    DocumentSnapshot docRatingSnapshot = await userCollection
        .doc(userID)
        .collection('Ratings')
        .doc(quizID)
        .get();
    if (docRatingSnapshot.exists) {
      return docRatingSnapshot['Rating'];
    } else {
      return 0;
    }
  }

  Future<void> updateQuizGlobalRating(
      {String? quizID, String? userID, int? rating, int? oldRating}) async {
    DocumentSnapshot docQuizSnapshot = await quizCollection.doc(quizID).get();
    if (rating! > 0) {
      int quizGlobalRating = docQuizSnapshot['QuizGlobalRating'];
      quizGlobalRating -= oldRating!;
      quizGlobalRating += rating!;

      await quizCollection.doc(quizID).update({
        'QuizGlobalRating': quizGlobalRating,
      });
    }
  }
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------