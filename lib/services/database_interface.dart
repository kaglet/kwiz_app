import '../models/quizzes.dart';
import '../models/user.dart';

abstract class DatabaseService {
  Future<List?> getCategories();
  Future<UserData?> getUserAndPastAttempts({String? userID});
  Future<UserData?> getUserAndBookmarks({String? userID});
  Future<void> addBookmarks({String? userID, Quiz? quiz});
  Future<void> deleteBookmarks({String? userID, String? quizID});
}
