import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';

class OurUser {
  final String? uid;

  OurUser({this.uid});
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
      required this.firstName,
      required this.userName,
      required this.lastName,
      required this.bookmarkedQuizzes,
      required this.pastAttemptQuizzes});
}
