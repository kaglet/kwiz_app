// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/shared/loading.dart';
import 'take_quiz.dart';
import '../services/database.dart';
import '../models/quizzes.dart';

class StartQuiz extends StatefulWidget {
  //This global variable will be passed onto the take_quiz screen
  final OurUser user;
  final String chosenQuiz;
  final String challID;
  const StartQuiz(
      {super.key,
      required this.chosenQuiz,
      required this.challID,
      required this.user});
  @override
  StartQuizState createState() => StartQuizState();
}

class StartQuizState extends State<StartQuiz> {
  late String info = '';
  late String category = '';
  late String title = '';
  late String dateCreated = '';
  String date = '';
  late String quizID = widget.chosenQuiz;
  late String challID = widget.challID;
  bool _isLoading = true;

//Depending on the quiz chosen by the user on the previous page, this loads the quiz's information namely its title and description
  Future<void> loaddata() async {
    Quiz? details;
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
    details = await service.getQuizInformationOnly(quizID: quizID);
    title = details!.quizName;
    info = details.quizDescription;
    category = details.quizCategory;
    dateCreated = details.quizDateCreated;
    date = dateCreated.substring(0, 10);
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
      backgroundColor: const Color.fromARGB(255, 27, 57, 82),
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
      //The entire body is wrapped with a SingleChild Scroll view that ensures that the page is scrollable vertically so that the user can always see all the components
      body: _isLoading
          ? Loading()
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
                        Visibility(
                          visible: challID != "None",
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'This is a challenge quiz. Good Luck!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        Center(
                          child: Image.asset(
                              //This loads the gif repsective to the quiz's category
                              'assets/images/$category.gif',
                              height: 500,
                              width: 500,
                              scale: 0.5,
                              opacity: const AlwaysStoppedAnimation<double>(1)),
                        ),
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
                                      text: info,
                                      style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
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
                                              builder: (context) => QuizScreen(
                                                    quizID,
                                                    user: widget.user,
                                                    challID: challID,
                                                  )),
                                        );
                                      },
                                      child: const Text(
                                        'Start',
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

// coverage:ignore-end