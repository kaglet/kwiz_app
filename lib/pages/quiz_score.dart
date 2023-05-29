//import 'dart:ffi';
// coverage:ignore-start
import 'package:flutter/material.dart';
import 'package:kwiz_v2/classes/rating_ui.dart';
import 'package:kwiz_v2/models/challenges.dart';
import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../services/database.dart';
import '../models/quizzes.dart';
import 'package:kwiz_v2/models/user.dart';
import '../models/rating.dart';

class QuizScore extends StatefulWidget {
  //This global variable will be passed onto the take_quiz screen
  final OurUser user;
  final Quiz? chosenQuiz;
  final int score;
  final List userAnswers;
  final String challID;
  final List answers;
  const QuizScore(
      {super.key,
      required this.chosenQuiz,
      required this.score,
      required this.userAnswers,
      required this.answers,
      required this.challID,
      required this.user});
  @override
  QuizScoreState createState() => QuizScoreState();
}

class QuizScoreState extends State<QuizScore> {
  //Rating variables
  late int? oldRating;
  late bool _ratingAlreadyExists;
  late int _rating;
  late String challID = widget.challID;
  //---------------------------------------
  late UserData userData;
  late OurUser user = widget.user!;
  late UserData userFriends;
  List<dynamic>? friendsList = [];
  int friendsListLength = 0;
  List<dynamic>? friends = [];
  int friendsLength = 0;
  List<dynamic>? _displayedItems = [];
  int fillLength = 0;

  late String username = '';
  late String quizID = widget.chosenQuiz!.quizID;
  bool isfirstAttempt = true;
  late int score = widget.score;
  late double quizPassScore = quizMaxScore / 2.floor();
  late List userAnswers = widget.userAnswers;
  late String userID = widget.user.uid.toString();
  late String title;
  late int quizMaxScore = widget.answers.length;
  //late List<String> answers = [];
  late List<int> markHistories = [];
  bool _isLoading = true;
  late int totalQuizzes;
  late double totalScore;
  late int numQuestions;

  Future<void> createRating() async {
    setState(() {
      _isLoading = true;
    });
    if (_rating > 0) {
      DatabaseService service =
          DatabaseService(); //This database service allows me to use all the functions in the database.dart file
      await service.createRating(
        userID: userID,
        quizID: widget.chosenQuiz?.quizID,
        rating: _rating,
      );
    }

    setState(() {
      _isLoading = false;
    });
    //Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> addChallenge(String friendID) async {
    Challenge newChallenge = Challenge(
        quizID: quizID,
        dateSent: DateTime.now().toString().substring(0, 16),
        dateCompleted: "",
        receiverID: friendID,
        senderID: userID,
        receiverMark: 0,
        senderMark: score,
        challengeID: "",
        senderName: username,
        quizName: widget.chosenQuiz!.quizName,
        challengeStatus: 'Pending');

    DatabaseService service = DatabaseService();
    // setState(() {
    //   _isLoading = true;
    // });
    await service.addChallenge(newChallenge);
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> updateChallenge(String challID) async {
    setState(() {
      _isLoading = true;
    });
    DatabaseService service = DatabaseService();
    Challenge? currChallenge =
        await service.getChallengeForReview(challengeID: challID);
    print(currChallenge?.challengeStatus);

    currChallenge?.dateCompleted = DateTime.now().toString().substring(0, 16);
    currChallenge?.receiverMark = score;
    currChallenge?.challengeStatus = "Closed";

    await service.updateChallenge(currChallenge!);
     setState(() {
      _isLoading = false;
    });
  }

  /// This function adds the user's rating to the global rating of a quiz in a database.
  Future<void> addToGlobalRating() async {
    setState(() {
      _isLoading = true;
    });
    if (_rating > 0) {
      DatabaseService service =
          DatabaseService(); //This database service allows me to use all the functions in the database.dart file
      await service.addToQuizGlobalRating(
          quizID: widget.chosenQuiz?.quizID, rating: _rating);
    }
    setState(() {
      _isLoading = false;
    });
    //Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> updateGlobalRating() async {
    setState(() {
      _isLoading = true;
    });
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
    await service.updateQuizGlobalRating(
        quizID: widget.chosenQuiz?.quizID,
        userID: widget.user.uid,
        rating: _rating,
        oldRating: oldRating);

    setState(() {
      _isLoading = false;
    });
  }

  //Navigator.popUntil(context, (route) => route.isFirst);

  Future<void> updateRating() async {
    setState(() {
      _isLoading = true;
    });
    if (_rating > 0) {
      DatabaseService service =
          DatabaseService(); //This database service allows me to use all the functions in the database.dart file
      await service.updateRating(
        userID: userID,
        quizID: widget.chosenQuiz?.quizID,
        rating: _rating,
      );
      //await service.updateQuizGlobalRating(rating: rating);
    }
    setState(() {
      _isLoading = false;
    });
    //Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> createAttempt() async {
    setState(() {
      _isLoading = true;
    });
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
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
    //Navigator.popUntil(context, (route) => route.isFirst);
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
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
    await service.addPastAttempt(
        userID: userID,
        quizMarks: markHistories,
        quizDateAttempted: DateTime.now().toString().substring(0, 16),
        quizID: widget.chosenQuiz!.quizID);
    setState(() {
      _isLoading = false;
    });
    //Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> updateScore() async {
    setState(() {
      _isLoading = true;
    });
    totalQuizzes++;
    totalScore += score / numQuestions;
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
    await service.updateUserScore(
        userID: userID,
        totalQuizzes: totalQuizzes,
        totalScore: totalScore.toString());
    setState(() {
      _isLoading = false;
    });
  }

//Depending on the quiz chosen by the user on the previous page, this loads the quiz's information namely its title and description
  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    _rating = -1;
    Quiz? details;
    DatabaseService service =
        DatabaseService(); //This database service allows me to use all the functions in the database.dart file
    details = await service.getQuizAndQuestions(quizID: quizID);
    title = details!.quizName;
    userData = (await service.getUserAndPastAttempts(userID: widget.user.uid))!;
    userID = userData.uID!;
    _ratingAlreadyExists = await service.ratingAlreadyExists(
        userID: widget.user.uid, quizID: widget.chosenQuiz?.quizID);
    oldRating = await service.getOldRating(
        userID: widget.user.uid, quizID: widget.chosenQuiz?.quizID);
    totalQuizzes = userData.totalQuizzes;
    totalScore = double.parse(userData.totalScore);
    numQuestions = details.quizQuestions.length;

    // for (int i = 0; i < quizMaxScore; i++) {
    //   answers.add(details.quizQuestions.elementAt(i).questionAnswer);
    // }
    //print(answers);
    setState(() {
      _isLoading = false;
    });
  }

//This ensures that the quiz information and category image/gif have loaded
  @override
  void initState() {
    super.initState();
    // do database stuff here and pass into loaddata function to populate page
    //_startLoading(); Michael flag: Implementing this caused errors probably because _isLoading is set to false then the widget skipped loading, keeping commented here in case
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              automaticallyImplyLeading: false,
            ),
      //The entire body is wrapped with a SingleChild Scroll view that ensures that the page is scrollable vertically so that the user can always see all the components
      body: _isLoading
          ? Loading()
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  height: screenHeight + 400,
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
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //This container displays the selected quiz's information and the start button
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(0),
                          //   color: const Color.fromARGB(255, 45, 64, 96),
                          // ),
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color: const Color.fromARGB(240, 45, 64, 96),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(children: [
                                    Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          text: "Rate This Quiz",
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 42,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RatingUI(
                                          (rating) {
                                            setState(() {
                                              _rating = rating;
                                            });
                                          },
                                          initialRating: oldRating,
                                        ),
                                        SizedBox(
                                            height: 44,
                                            child: (_rating != null &&
                                                    _rating != 0 &&
                                                    _rating != -1)
                                                ? Text(
                                                    "Rate this $_rating stars",
                                                    style:
                                                        TextStyle(fontSize: 18))
                                                : SizedBox.shrink())
                                      ],
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: score >= quizPassScore
                                          ? "Well done! \nYou passed with a score of "
                                          : score >= quizMaxScore * 0.75
                                              ? "You were close! \nYou scored "
                                              : score >= quizMaxScore * 0.5
                                                  ? "You have some room for improvement. \nYou scored "
                                                  : "You need to study more. \nYou scored ",
                                      style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "$score/$quizMaxScore\n",
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: score >= quizPassScore
                                                ? const Color.fromARGB(
                                                    255, 82, 177, 255)
                                                : const Color.fromARGB(
                                                    255, 230, 131, 44),
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                offset: const Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                      color: Color.fromARGB(255, 230, 131, 44),
                                    ),
                                    children: List.generate(
                                        widget.answers.length, (index) {
                                      return TextSpan(
                                        text:
                                            '${index + 1}. ${widget.answers[index]}\n',
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
                                      color: Color.fromARGB(255, 230, 131, 44),
                                    ),
                                    children: List.generate(userAnswers.length,
                                        (index) {
                                      return TextSpan(
                                        text:
                                            '${index + 1}. ${userAnswers[index]}\n',
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

                                //challenge a friend button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 60, 44, 167),
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
                                        print(username);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Friend List'),
                                              content: Container(
                                                width: double.maxFinite,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: fillLength,
                                                        itemBuilder:
                                                            (context, index) {
                                                          //final String name = friends![index];
                                                          return ListTile(
                                                            title: Text(
                                                              _displayedItems?[
                                                                      index]
                                                                  .friendName,
                                                            ),
                                                            trailing:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                addChallenge(
                                                                    _displayedItems?[
                                                                            index]
                                                                        .friendID);
                                                              },
                                                              child: Text(
                                                                  'Challenge'),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },

                                      child: const Text(
                                        'Challenge a friend!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //to add spaces between the two buttons

                                const SizedBox(
                                  height: 30,
                                ),
                                //Finish review button
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
                                        if (challID != "None") {
                                          updateChallenge(challID);
                                        }

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

                                        if (_ratingAlreadyExists) {
                                          updateGlobalRating();
                                          updateRating();
                                        } else {
                                          createRating();
                                          addToGlobalRating();
                                        }

                                        updateScore();

                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
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

// coverage:ignore-end