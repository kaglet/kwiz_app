//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/pages/home.dart';
import '../services/database.dart';
import '../models/quizzes.dart';
import 'package:kwiz_v2/models/user.dart';

class QuizScore extends StatefulWidget {
  //This global variable will be passed onto the take_quiz screen
  final OurUser user;
  final Quiz? chosenQuiz;
  final int score;
  final List userAnswers;
  final List answers;
  const QuizScore(
      {super.key,
      required this.chosenQuiz,
      required this.score,
      required this.userAnswers,
      required this.answers,
      required this.user});
  @override
  QuizScoreState createState() => QuizScoreState();
}

class QuizScoreState extends State<QuizScore> {
  late UserData userData;
  late String quizID = widget.chosenQuiz!.quizID;
  bool isfirstAttempt = true;
  late int score = widget.score;
  late double quizPassScore = quizMaxScore/2.floor();
  late List userAnswers = widget.userAnswers;
  late String userID = widget.user.uid.toString();
  late String title;
  late int quizMaxScore = widget.answers.length;
  //late List<String> answers = [];
  late List<int> markHistories = [];
  bool _isLoading = true;
  DatabaseService service =
      DatabaseService(); //This database service allows me to use all the functions in the database.dart file

  Future<void> createAttempt() async {
    setState(() {
      _isLoading = true;
    });
    await service.createPastAttempt(
      userID: userID,
      quiz: widget.chosenQuiz,
      quizMark: score,
      quizAuthor: widget.chosenQuiz!.quizAuthor,
      quizDateAttempted: DateTime.now().toString().substring(0, 16),
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> updateAttempt() async {
    setState(() {
      _isLoading = true;
    });
    //append array of marks and datetime. MAnually. send through to db and overwrite

    userData.pastAttemptQuizzes.forEach((element) {
      if (element.quizID == quizID) {
        markHistories = element.pastAttemptQuizMarks;
        markHistories.add(score);
      }
    });
    await service.addPastAttempt(
        userID: userID,
        quizMarks: markHistories,
        quizDateAttempted: DateTime.now().toString().substring(0, 16),
        quizID: widget.chosenQuiz!.quizID);
    setState(() {
      _isLoading = false;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

//Depending on the quiz chosen by the user on the previous page, this loads the quiz's information namely its title and description
  Future<void> loaddata() async {
    Quiz? details;
    details = await service.getQuizAndQuestions(quizID: quizID);
    title = details!.quizName;
    userData = (await service.getUserAndPastAttempts(userID: widget.user.uid))!;

    
    // for (int i = 0; i < quizMaxScore; i++) {
    //   answers.add(details.quizQuestions.elementAt(i).questionAnswer);
    // }
    //print(answers);
  }

//This ensures that the quiz information and category image/gif have loaded
  @override
  void initState() {
    super.initState();
    _startLoading();
    loaddata().then((value) {
      setState(() {});
    });
  }

//Used to control the Circular Progress indicator
  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 57, 82),
      resizeToAvoidBottomInset: false,
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text(
                title,
                style: const TextStyle(
                    fontFamily: 'TitanOne',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              backgroundColor: const Color.fromARGB(255, 27, 57, 82),
            ),
      //The entire body is wrapped with a SingleChild Scroll view that ensures that the page is scrollable vertically so that the user can always see all the components
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  //The entire body is wrapped with a container so that we can get the background with a gradient effect
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //This container displays the selected quiz's information and the start button
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: const Color.fromARGB(255, 45, 64, 96),
                          ),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //This widget displays the quiz's title
                                // Text(
                                //   title,
                                //   style: const TextStyle(
                                //       fontFamily: 'Nunito',
                                //       fontSize: 30,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.white,
                                //       decoration: TextDecoration.underline),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  //This widget displays the quiz's information
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: score >= quizPassScore ? "Well done! You passed with a score of $score/$quizMaxScore!\n" :
                                        score >= quizMaxScore * 0.75 ? "You were close! You scored $score/$quizMaxScore.\n" :
                                        score >= quizMaxScore * 0.5 ? "You have some room for improvement. You scored $score/$quizMaxScore.\n" :
                                        "You need to study more. You scored $score/$quizMaxScore.\n",
                                      style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                      RichText(
                                        textAlign: TextAlign.left,
                                        //This widget displays the date the quiz was created
                                        text: TextSpan(
                                          text: 'The correct answers were:\n',
                                          style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                          children: List.generate(widget.answers.length, (index) {
                                            return TextSpan(
                                              text: '${index + 1}. ${widget.answers[index]}\n',
                                              style: const TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          text: 'Your answers were:\n',
                                          style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                          children: List.generate(userAnswers.length, (index) {
                                            return TextSpan(
                                              text: '${index + 1}. ${userAnswers[index]}\n',
                                              style: const TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.orange,
                                          Colors.deepOrange
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      //This event takes us to the take_quiz screen
                                      onPressed: () {
                                        if (userData
                                            .pastAttemptQuizzes.isEmpty) {
                                          isfirstAttempt = true;
                                        } else {
                                          //
                                          userData.pastAttemptQuizzes
                                              .forEach((element) {
                                            if (element.quizID == quizID) {
                                              isfirstAttempt = false;
                                            }
                                          });
                                        }

                                        if (isfirstAttempt) {
                                          createAttempt();
                                        } else {
                                          updateAttempt();
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Home(user: widget.user)),
                                        );
                                      },
                                      child: const Text(
                                        'Finish Review',
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
