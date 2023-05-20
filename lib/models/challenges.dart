class Challenge {
//Used so you can naviagte to the quiz from viewing bookmarks
  final String quizID;
  final String dateSent;
  final String dateCompleted;
  final String receiverID;
  final String senderID;
  final int receiverMark;
  final int senderMark;
  final String challengeID;

  Challenge(
      {required this.quizID,
      required this.dateSent,
      required this.dateCompleted,
      required this.receiverID,
      required this.senderID,
      required this.receiverMark,
      required this.senderMark,
      required this.challengeID});
}
