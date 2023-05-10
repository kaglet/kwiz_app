import '../models/questions.dart';

class Quiz {
  final String quizName;
  final String quizCategory;
  final String quizDescription;
  final int quizMark;
  final String quizDateCreated;
  //Kago wont send this through
  final String quizID;
  final int quizGlobalRating;
  final int quizTotalRatings;

  late final List<Question> quizQuestions;

  final String quizAuthor;

  Quiz(
      {required this.quizName,
      required this.quizCategory,
      required this.quizDescription,
      required this.quizMark,
      required this.quizDateCreated,
      required this.quizQuestions,
      required this.quizID,
      required this.quizAuthor,
      required this.quizGlobalRating,
      required this.quizTotalRatings});
}
