import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';

class OurUser {
  final String? uid;

  OurUser({required this.uid});
}

class UserData {
  final String? uID;
  final String userName;
  final String firstName;
  final String lastName;
  late final List<Bookmarks> bookmarkedQuizzes;
  late final List<PastAttempt> pastAttemptQuizzes;

  UserData(
      {required this.uID,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.bookmarkedQuizzes,
      required this.pastAttemptQuizzes});
}
