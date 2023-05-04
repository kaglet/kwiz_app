class Question {
  final int questionNumber;
  final String questionText;
  final String questionAnswer;
  final int questionMark;
  final String questionType;

  Question(
      {required this.questionNumber,
      required this.questionText,
      required this.questionAnswer,
      required this.questionMark,
      required this.questionType});
}

class MultipleAnswerQuestion extends Question {
  final List<String> answerOptions;

  MultipleAnswerQuestion({
    required int questionNumber,
    required String questionText,
    required String questionAnswer,
    required int questionMark,
    required String questionType,
    required this.answerOptions,
  }) : super(
            questionNumber: questionNumber,
            questionText: questionText,
            questionAnswer: questionAnswer,
            questionMark: questionMark,
            questionType: questionType);
}
