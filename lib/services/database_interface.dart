import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/models/quizzes.dart';

import '../models/quizzes.dart';
import '../models/user.dart';

abstract class DatabaseService {
  Future<List?> getCategories();
  Future<void> addQuizWithQuestions(Quiz quizInstance);
  Future<UserData?> getUserAndPastAttempts({String? userID});
  Future<UserData?> getUserAndBookmarks({String? userID});
  Future<void> addBookmarks({String? userID, Quiz? quiz});
  Future<void> deleteBookmarks({String? userID, String? quizID});
  Future<UserData?> getUser(String? uid);
  Future<UserData?> addUser(UserData userInstance, OurUser ourUserInstance);
  Future<List<Quiz>?> getAllQuizzes();
  Future<Quiz?> getQuizAndQuestions({String? quizId});
  Future<List<Quiz>?> getQuizByCategory({String? category});
  Future<Quiz?> getQuizInformationOnly({String? quizID});
  Future<PastAttempt> createPastAttempt(
      {String? userID,
      Quiz? quiz,
      int? quizMark,
      String? quizDateAttempted,
      required String quizAuthor});
  Future<PastAttempt> addPastAttempt(
      {String? userID,
      List<int>? quizMarks,
      String? quizDateAttempted,
      String? quizID});
}
