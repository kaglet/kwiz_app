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
  Future<List<Quiz>?> getAllQuizzes();
}
