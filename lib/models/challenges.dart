class Challenge {
//Used so you can naviagte to the quiz from viewing bookmarks
  final String quizID;
  final String dateSent;
  final String dateCompleted;
  final String receiverID;
  final String senderID;
  final int? receiverMark;
  final int senderMark;
  final String? challengeID;
  final String senderName;
  final String quizName;
  final String challengeStatus;

  Challenge(
      {required this.quizID,
      required this.dateSent,
      required this.dateCompleted,
      required this.receiverID,
      required this.senderID,
      required this.receiverMark,
      required this.senderMark,
      required this.challengeID,
      required this.senderName,
      required this.quizName,
      required this.challengeStatus});
}
