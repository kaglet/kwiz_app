import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/add_quiz_about.dart';
import 'package:kwiz_v2/pages/profile.dart';
import 'package:kwiz_v2/pages/view_categories.dart';
import 'package:kwiz_v2/pages/take_quiz.dart';
import '../models/quizzes.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'dart:math';
// import 'add_quiz_about.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int allQuizzesLength = 0;
  int randNum = 0;
  Random random = Random();
  DatabaseService service = DatabaseService();
  List<Quiz>? quizzes;

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {});
    });
  }

  // loads data from DB
  Future<void> loadData() async {
    quizzes = await service.getAllQuizzes();
    allQuizzesLength = quizzes!.length;
    randNum = random.nextInt(allQuizzesLength + 1);
    textControllerTitle.text = quizzes!.elementAt(randNum).quizName;
    textControllerDesc.text = quizzes!.elementAt(randNum).quizDescription;
  }

  @override
  // return static home screen with navigation functionality //
  final AuthService _auth = AuthService();
  TextEditingController textControllerTitle = TextEditingController();
  TextEditingController textControllerDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 250.0,
                        height: 70.0,
                        child: Text(
                          'Hello Kago, Welcome back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                            fontFamily: 'TitanOne',
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                          size: 40.0,
                        ),
                        onPressed: () async {
                          await _auth.signOut();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Profile()),
                          );
                        },
                      ),
                    ]),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  decoration:
                      const BoxDecoration(color: Color.fromRGBO(46, 46, 50, 0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          const SizedBox(
                            width: 30.0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: const Center(
                              child: Text(
                                'Surprise me!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 35.0,
                          ),
                          SizedBox(
                            width: 90,
                            height: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 230, 131, 44),
                                    Color.fromARGB(255, 244, 112, 72),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal),
                                ),
                                //This event takes us to the take_quiz screen
                                onPressed: () {
                                  randNum =
                                      random.nextInt(allQuizzesLength + 1);
                                  textControllerTitle.text =
                                      quizzes!.elementAt(randNum).quizName;
                                  textControllerDesc.text = quizzes!
                                      .elementAt(randNum)
                                      .quizDescription;
                                },
                                child: const Text(
                                  'Randomize',
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          quizzes == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Expanded(
                                
                                  child: IntrinsicHeight(
                                    child: SizedBox(
                                      height:
                                          200, // set a fixed height for the container
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 45, 64, 96),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 0),
                                        child: SizedBox(
                                          height:
                                              200, // set a fixed height for the SingleChildScrollView
                                          child: SingleChildScrollView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      textControllerTitle,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      decoration: TextDecoration
                                                          .underline),
                                                  maxLines:
                                                      null, // set maxLines to null or a higher value
                                                  textInputAction: TextInputAction
                                                      .newline, // enable line breaks
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  //This widget displays the quiz's information

                                                  child: TextField(
                                                    controller:
                                                        textControllerDesc,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                    maxLines:
                                                        null, // set maxLines to null or a higher value
                                                    textInputAction: TextInputAction
                                                        .newline, // enable line breaks
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 30,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color.fromARGB(255,
                                                              230, 131, 44),
                                                          Color.fromARGB(255,
                                                              244, 112, 72),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal),
                                                      ),
                                                      //This event takes us to the take_quiz screen
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                QuizScreen(quizzes!
                                                                    .elementAt(
                                                                        randNum)
                                                                    .quizID),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Start',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Nunito',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 120.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewCategories()),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 230, 131, 44),
                                          Color.fromARGB(255, 244, 112, 72),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Browse our quizzes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 120.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddQuiz()),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 222, 127, 43),
                                          Color.fromARGB(255, 246, 120, 82),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Add custom quiz',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}