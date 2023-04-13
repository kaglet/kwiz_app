import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';

class ourUser {
  final String? uid;

  ourUser({this.uid});
}

class UserData {
  final String? uid;
  final String? userName;
  final String? firstName;
  final String? lastName;
  late final List<Bookmarks> bookmarkedQuizzes;
  late final List<PastAttempt> pastAttemptQuizzes;

  UserData(
      {required this.uid,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.bookmarkedQuizzes,
      required this.pastAttemptQuizzes});
}
