class QA {
  String question;
  String answer;
  String type;
  
  QA({required this.question, required this.answer, required this.type});
}

class QAMultiple extends QA {
  List<String> answerOptions;
  
  QAMultiple({required  String question, required String answer, required String type, required this.answerOptions}) 
  : super(question: question, answer: answer, type: type);
}

