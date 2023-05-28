import '../models/rating.dart';
import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';
import '../models/friend.dart';

class OurUser {
  final String? uid;

  OurUser({required this.uid});
}

class UserData {
  final String? uID;
  final String userName;
  final String firstName;
  final String lastName;
  final int totalQuizzes;
  final String totalScore;
  late final List<Bookmarks> bookmarkedQuizzes;
  late final List<PastAttempt> pastAttemptQuizzes;
  late final List<Rating> ratings;
  late final List<Friend> friends;

  UserData(
      {required this.uID,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.totalScore,
      required this.totalQuizzes,
      required this.bookmarkedQuizzes,
      required this.pastAttemptQuizzes,
      required this.ratings,
      required this.friends});
}
