// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/classes/time_helper.dart';
import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/add_quiz_about.dart';
import 'package:kwiz_v2/pages/profile.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import 'package:kwiz_v2/pages/view_categories.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../models/quizzes.dart';
import '../services/auth.dart';
import 'dart:math';

import 'leaderboard.dart';
// import 'add_quiz_about.dart';

class Home extends StatefulWidget {
  final OurUser user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  int allQuizzesLength = 0;
  int randNum = 0;
  Random random = Random();
  DatabaseService service = DatabaseService();
  List<Quiz>? quizzes;
  late bool _isLoading = true;

  final _tween = Tween<Offset>(
    begin: Offset(1.0, 0.0),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    loadData().then((value) {
      setState(() {});
    });
  }

  // loads data from DB
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    quizzes = await service.getAllQuizzes();
    allQuizzesLength = quizzes!.length;
    randNum = random.nextInt(allQuizzesLength);
    textControllerTitle.text = quizzes!.elementAt(randNum).quizName;
    textControllerCat.text = quizzes!.elementAt(randNum).quizCategory;

    currentUser = await service.getUser(widget.user.uid);

    setState(() {
      _isLoading = false;
    });
  }

  // return static home screen with navigation functionality //

  UserData? currentUser = UserData(
      uID: ' ',
      userName: ' ',
      firstName: ' ',
      lastName: ' ',
      totalScore: ' ',
      totalQuizzes: 0,
      bookmarkedQuizzes: [],
      pastAttemptQuizzes: [],
      ratings: []);

  TextEditingController textControllerTitle = TextEditingController();
  TextEditingController textControllerCat = TextEditingController();

  late OverlayEntry overlayEntry;
  late AnimationController _controller;

  bool isOverlayShowing = false;

  void setOverlayShowing(bool value) {
    setState(() {
      isOverlayShowing = value;
    });
  }

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: SlideTransition(
            position: _tween.animate(_controller),
            child: Material(
                child: Profile(
                    user: widget.user,
                    controller: _controller,
                    onOverlayClose: setOverlayShowing)),
          ),
        );
      },
    );

    setState(() {
      isOverlayShowing = true;
    });

    Overlay.of(context)!.insert(overlayEntry);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
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
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: SizedBox(
                                              // width: 200.0,
                                              // height: 70.0,
                                              child: Text(
                                                'Good ${TimeHelper.getTimeOfTheDay(DateTime.now())} ${currentUser!.userName}!',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 2.0,
                                                  fontFamily: 'TitanOne',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setOverlayShowing(true);
                                                showOverlay(context);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 16.0),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(46, 46, 50, 0)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 30.0),
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 30.0,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: const Center(
                                                  child: Text(
                                                    'Surprise me!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1.0,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  width: 95,
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
                                                              9),
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
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal),
                                                      ),
                                                      //This event takes us to the take_quiz screen
                                                      onPressed: () {
                                                        randNum = random.nextInt(
                                                            allQuizzesLength);
                                                        textControllerTitle
                                                                .text =
                                                            quizzes!
                                                                .elementAt(
                                                                    randNum)
                                                                .quizName;
                                                        textControllerCat.text =
                                                            quizzes!
                                                                .elementAt(
                                                                    randNum)
                                                                .quizCategory;
                                                      },
                                                      child: const Text(
                                                        'Randomize',
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
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                //  child: IntrinsicHeight(
                                                child: SizedBox(
                                                  height:
                                                      180, // set a fixed height for the container
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 45, 64, 96),
                                                    ),
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 10, 15, 0),
                                                    child: SizedBox(
                                                      height:
                                                          200, // set a fixed height for the SingleChildScrollView
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const AlwaysScrollableScrollPhysics(),
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  textControllerTitle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                              maxLines:
                                                                  null, // set maxLines to null or a higher value
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .newline,
                                                              enabled:
                                                                  false, // enable line breaks
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                              //This widget displays the quiz's information

                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .baseline,
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                children: [
                                                                  const Text(
                                                                    'Category:',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          230,
                                                                          131,
                                                                          44),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          20,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          textControllerCat,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      maxLines:
                                                                          null,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .newline,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      enabled:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 30,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          230,
                                                                          230,
                                                                          131,
                                                                          44),
                                                                      Color.fromARGB(
                                                                          230,
                                                                          244,
                                                                          112,
                                                                          72),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontStyle:
                                                                            FontStyle.normal),
                                                                  ),
                                                                  //This event takes us to the take_quiz screen
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => StartQuiz(
                                                                            user:
                                                                                widget.user,
                                                                            chosenQuiz: quizzes!.elementAt(randNum).quizID),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Start',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 100.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Leaderboard(
                                                                    user: widget
                                                                        .user)),
                                                      );
                                                    },
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  230,
                                                                  131,
                                                                  44),
                                                              Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  112,
                                                                  72),
                                                            ],
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'View Leaderboard',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0,
                                                              fontFamily:
                                                                  'Nunito',
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
                                            height: 30.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 100.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewCategories(
                                                                    user: widget
                                                                        .user)),
                                                      );
                                                    },
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  230,
                                                                  131,
                                                                  44),
                                                              Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  112,
                                                                  72),
                                                            ],
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Browse our quizzes',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0,
                                                              fontFamily:
                                                                  'Nunito',
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
                                            height: 30.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 100.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddQuiz(
                                                                      user: widget
                                                                          .user,
                                                                    )),
                                                      );
                                                    },
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  230,
                                                                  131,
                                                                  44),
                                                              Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  112,
                                                                  72),
                                                            ],
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Add custom quiz',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0,
                                                              fontFamily:
                                                                  'Nunito',
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Add grey effect when popup is showing
              if (isOverlayShowing)
                Container(
                  color: Colors.grey.withOpacity(0.5),
                ),
            ],
          );
  }
}

// coverage:ignore-end
