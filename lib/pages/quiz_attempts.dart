// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import '../models/pastAttempt.dart';
import '../models/user.dart';
import '../services/database.dart';

class QuizAttempts extends StatefulWidget {
  // receive data on user and chosen quiz from quiz history page
  final OurUser user;
  final PastAttempt chosenQuiz;
  const QuizAttempts({super.key, required this.user, required this.chosenQuiz});
  @override
  // ignore: library_private_types_in_public_api
  _QuizAttemptsState createState() => _QuizAttemptsState();
}

class _QuizAttemptsState extends State<QuizAttempts> {
  late PastAttempt pastAttempt;
  int fillLength = 0;

  @override
  void initState() {
    super.initState();
    pastAttempt = widget.chosenQuiz;
    fillLength = pastAttempt.pastAttemptQuizMarks.length;
  }

  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pastAttempt.pastAttemptQuizName + ' Attempts',
          style: const TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        backgroundColor: const Color.fromARGB(255, 27, 57, 82),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 27, 57, 82),
              Color.fromARGB(255, 5, 12, 31),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                  ),
                  // With a list view builder populate all attempts for a quiz
                  ListView.builder(
                    itemCount: fillLength,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 45, 64, 96),
                                Color.fromARGB(255, 45, 64, 96),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(children: <Widget>[
                              // show mark and date taken per past attempt
                              Text('Attempt Number ${index + 1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                              Text(
                                  'Score: ${pastAttempt.pastAttemptQuizMarks[index]}'),
                              Text('Date Taken: ' +
                                  pastAttempt
                                      .pastAttemptQuizDatesAttempted[index])
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 380,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                  ),
                  // This event takes us to the take_quiz screen to reattempt a quiz
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartQuiz(
                                user: widget.user,
                                chosenQuiz: pastAttempt.quizID,
                              )),
                    );
                  },
                  child: const Text(
                    'Re-attempt Quiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// coverage:ignore-end
