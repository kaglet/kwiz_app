class PastAttempt {
//Used so you can naviagte to the quiz from viewing past attempts
  final String quizID;
  final String pastAttemptQuizAuthor;
  final String pastAttemptQuizName;
  final String pastAttemptQuizCategory;
  final String pastAttemptQuizDescription;
  final String pastAttemptQuizDateCreated;
  final int pastAttemptQuizMark;

//List of the Marks and dates(indexs match eachother.. index 0 of pastAttemptQuizMarks is the mark of the quiz taken on index 0 of pastAttemptQuizDatesTaken)
  late final List<int> pastAttemptQuizMarks;
  late final List<String> pastAttemptQuizDatesAttempted;

  PastAttempt({
    required this.quizID,
    required this.pastAttemptQuizAuthor,
    required this.pastAttemptQuizName,
    required this.pastAttemptQuizCategory,
    required this.pastAttemptQuizDescription,
    required this.pastAttemptQuizDateCreated,
    required this.pastAttemptQuizMark,
    required this.pastAttemptQuizMarks,
    required this.pastAttemptQuizDatesAttempted,
  });
}
