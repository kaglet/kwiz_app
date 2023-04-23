import '../models/quizzes.dart';
import '../models/user.dart';

abstract class DatabaseService {
  Future<List?> getCategories();
  Future<UserData?> getUserAndPastAttempts({String? userID});
  Future<UserData?> getUserAndBookmarks({String? userID});
  Future<UserData?> addBookmarks({String? userID, Quiz? quiz});
  Future<bool> deleteBookmarks({String? userID, String? quizID});
  Future<UserData?> getUser(String? uid);
  Future<UserData?> addUser(UserData userInstance, OurUser ourUserInstance);
}
