import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/home.dart';
import '../services/database.dart';
import '../models/quizzes.dart';

class QuizScore extends StatefulWidget {
  //This global variable will be passed onto the take_quiz screen
  final String chosenQuiz;
  final int score;
  final List userAnswers;
  const QuizScore({super.key, required this.chosenQuiz, required this.score, required this.userAnswers});
  @override
  QuizScoreState createState() => QuizScoreState();
}

class QuizScoreState extends State<QuizScore> {
  late String quizID = widget.chosenQuiz;
  late int score = widget.score;
  late List userAnswers = widget.userAnswers;
  late String title;
  late int quizMaxScore;
  bool _isLoading = true;
  DatabaseService service =
      DatabaseService(); //This database service allows me to use all the functions in the database.dart file

//Depending on the quiz chosen by the user on the previous page, this loads the quiz's information namely its title and description
  Future<void> loaddata() async {
    Quiz? details;
    details = await service.getQuizInformationOnly(quizID: quizID);
    title = details!.quizName;
    quizMaxScore = userAnswers.length;
    popList(details);
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

  void popList(Quiz q) {
    for (int i = 0; i < quizMaxScore; i++) {
      answers.add(q.quizQuestions.elementAt(i).questionAnswer);
    }
  }

  List<String> answers = [];

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
                              children: [
                                //This widget displays the quiz's title
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  //This widget displays the quiz's information
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: "Your scored $score/$quizMaxScore!",
                                      style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.left,
                                  //This widget displays the date the quiz was created
                                  text: TextSpan(
                                    text: 'The correct answers were: $answers . Your answers were: $userAnswers',
                                    style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 26,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Home()),
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
