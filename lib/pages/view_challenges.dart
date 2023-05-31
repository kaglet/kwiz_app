// coverage:ignore-start
// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/challenges.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/shared/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'start_quiz.dart';

class ViewChallenges extends StatefulWidget {
  final OurUser user;

  const ViewChallenges({super.key, required this.user});
  @override
  ViewChallengesState createState() => ViewChallengesState();
}

class ViewChallengesState extends State<ViewChallenges>
    with SingleTickerProviderStateMixin<ViewChallenges> {
  late TabController _tabController;
  List? challenges = [];
  List? pending = [];
  int pendingLength = 0;
  int activeLength = 0;
  int closedLength = 0;
  int sentLength = 0;
  List? active = [];
  List? closed = [];
  List? sent = [];
  late bool _isLoading;

  Future<void> rejectChallenge(int index) async {
    DatabaseService service = DatabaseService();
    await service.rejectChallengeRequest(
        challengeID: pending!.elementAt(index).challengeID);
  }

  Future<void> acceptChallenge(int index) async {
    DatabaseService service = DatabaseService();
    await service.acceptChallengeRequest(
        challengeID: pending!.elementAt(index).challengeID);
  }

  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    DatabaseService service = DatabaseService();
    challenges = (await service.getAllChallenges())!;
    // pending tab is from perspective where I am the receiver, challenge receiver is me
    // active and closed tabs are from perspective where I am the receiver or the sender (we'll switch display based on exact perspective later)
    // sent tab is from perspective where challenge sender is me
    pending = challenges!
        .where((challenge) =>
            challenge.challengeStatus == 'Pending' &&
            challenge.receiverID == widget.user.uid)
        .toList();
    active = challenges!
        .where((challenge) =>
            challenge.challengeStatus == 'Active' &&
            (challenge.receiverID == widget.user.uid ||
                challenge.senderID == widget.user.uid))
        .toList();
    closed = challenges!
        .where((challenge) =>
            challenge.challengeStatus == 'Closed' &&
            (challenge.receiverID == widget.user.uid ||
                challenge.senderID == widget.user.uid))
        .toList();

    // not just the rejected but the all the challenges the current sender has sent

    // print(widget.user.uid);
    sent = challenges!
        .where((challenge) => challenge.senderID == widget.user.uid)
        .toList();

    // pending.forEach((element) {
    //   print('Pending challenge ' + element.senderName);
    // });

    // active.forEach((element) {
    //   print('Active challenge ' + element.senderName);
    // });

    // closed.forEach((element) {
    //   print('Closed challenge ' + element.senderName);
    // });

    // challenges.forEach((element) {
    //   print('Sent challenge' + element.senderName);
    // });

    // for (var i = 0; i < challenges.length; i++) {
    //   print(closed.elementAt(i).dateSent);
    //   // service.acceptChallengeRequest(
    //   //     challengeID: closed!.elementAt(i).challengeID);
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _startLoading();
    loaddata().then((value) {
      setState(() {
        pendingLength = pending!.length;
        closedLength = closed!.length;
        activeLength = active!.length;
        sentLength = challenges!.length;
      });
    });
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(0);
    _tabController.addListener(() {
      setState(() {
        // setState(() {
        //   _isLoading = true;
        // });
        // _startLoading();
        pendingLength = pending!.length;
        closedLength = closed!.length;
        activeLength = active!.length;
        sentLength = challenges!.length;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Challenges',
          style: TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 60, 44, 167),
            indicatorWeight: 7,
            // indicator: BoxDecoration(
            // borderRadius: BorderRadius.circular(50), // Creates border
            // color: Colors.orange),
            labelStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito'),
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(text: 'Active'),
              Tab(
                text: 'Closed',
              ),
              Tab(
                text: 'Sent',
              )
            ]),
        backgroundColor: const Color.fromARGB(255, 27, 57, 82),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
            //Might need to do navigator.push because might lose user data
          },
        ),
      ),
      body: _isLoading
          ? Loading()
          : Container(
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
              child: TabBarView(controller: _tabController, children: [
                //Pending widgets ----------------------------------------------------------------------------------------------------------------------
                _isLoading
                    ? Loading()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: pendingLength,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 160.0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 60, 44, 167),
                                    Colors.deepOrange
                                  ],
                                ),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.elliptical(2, 3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Color.fromARGB(239, 30, 43, 66),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${pending![index].senderName} challenges you to the ${pending![index].quizName} quiz!',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontFamily: 'Nunito',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 60, 44, 167),
                                                        Colors.deepOrange
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top: Radius
                                                                .elliptical(
                                                                    100, 100),
                                                            bottom: Radius
                                                                .elliptical(
                                                                    100, 100)),
                                                  ),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      acceptChallenge(index);
                                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                                      //           SnackBar(
                                                      // content: Text('Challenge Accepted11111!'),
                                                      // action: SnackBarAction(
                                                      //           onPressed: (){

                                                      //           },
                                                      // label: "DISMISS",
                                                      // //           ),
                                                      //         )
                                                      //       );
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Challenge Accepted!",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black54,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      _startLoading();
                                                      // Refresh the list of displayed items
                                                      setState(() {
                                                        active!.insert(
                                                            0,
                                                            pending!.elementAt(
                                                                index));
                                                        pending!
                                                            .removeAt(index);
                                                        pendingLength =
                                                            pending!.length;
                                                        print(pending!.length);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 60, 44, 167),
                                                        Colors.deepOrange
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top: Radius
                                                                .elliptical(
                                                                    100, 100),
                                                            bottom: Radius
                                                                .elliptical(
                                                                    100, 100)),
                                                  ),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      rejectChallenge(index);
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Challenge Rejected!",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black54,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      _startLoading();
                                                      // Refresh the list of displayed items
                                                      setState(() {
                                                        // filteredQuizzes!.removeAt(index);
                                                        pending!
                                                            .removeAt(index);
                                                        pendingLength =
                                                            pending!.length;
                                                        print(pending!.length);
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Reject',
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                // Active widgets --------------------------------------------------------------------------------------------------------------------
                _isLoading
                    ? Loading()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: activeLength,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 160.0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 60, 44, 167),
                                    Colors.deepOrange
                                  ],
                                ),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.elliptical(2, 3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Color.fromARGB(239, 30, 43, 66),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                if (active![index].senderID ==
                                                    widget.user.uid) ...[
                                                  TextSpan(
                                                    text:
                                                        '${active![index].quizName} quiz challenge VS ${active![index].receiverName}!',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ] else ...[
                                                  TextSpan(
                                                    text:
                                                        '${active![index].quizName} quiz challenge VS ${active![index].senderName}!',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 60, 44, 167),
                                                        Colors.deepOrange
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top: Radius
                                                                .elliptical(
                                                                    100, 100),
                                                            bottom: Radius
                                                                .elliptical(
                                                                    100, 100)),
                                                  ),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      acceptChallenge(index);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => StartQuiz(
                                                              user: widget.user,
                                                              chosenQuiz:
                                                                  active![index]
                                                                      .quizID,
                                                              challID: active![
                                                                      index]
                                                                  .challengeID),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Take Quiz',
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                // Closed widgets --------------------------------------------------------------------------------------------------------------------
                _isLoading
                    ? Loading()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: closedLength,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 160.0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 60, 44, 167),
                                    Colors.deepOrange
                                  ],
                                ),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.elliptical(2, 3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Color.fromARGB(239, 30, 43, 66),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            'Completed ${closed![index].quizName} quiz challenge vs ${closed![index].senderName}!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito',
                                                fontSize: 17)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 60, 44, 167),
                                                      Colors.deepOrange
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top:
                                                              Radius.elliptical(
                                                                  100, 100),
                                                          bottom:
                                                              Radius.elliptical(
                                                                  100, 100)),
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    String result = '';
                                                    if (closed![index]
                                                            .receiverMark! >
                                                        closed![index]
                                                            .senderMark!) {
                                                      result = 'Victory';
                                                    } else if (closed![index]
                                                            .receiverMark ==
                                                        closed![index]
                                                            .senderMark) {
                                                      result = 'Draw';
                                                    } else {
                                                      result = 'Defeat';
                                                    }
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return WillPopScope(
                                                          onWillPop: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            return true;
                                                          },
                                                          child: AlertDialog(
                                                            backgroundColor: Colors
                                                                .transparent, // Set the background color to transparent
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            content: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    const LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            27,
                                                                            57,
                                                                            82),
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            5,
                                                                            12,
                                                                            31),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    result,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25.0,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'TitanOne',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Text(
                                                                    '${closed![index].quizName}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Text(
                                                                    'My score: ${closed![index].receiverMark}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Text(
                                                                    'Challenger\'s score: ${closed![index].senderMark}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Text(
                                                                    'Opened: ${closed![index].dateSent}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Text(
                                                                    'Closed: ${closed![index].dateCompleted}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      TextButton(
                                                                        // navigate to home screen
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                const LinearGradient(
                                                                              colors: [
                                                                                Colors.orange,
                                                                                Colors.orange,
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical: 10.0,
                                                                              horizontal: 20.0),
                                                                          child:
                                                                              const Text(
                                                                            'Close',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1.0,
                                                                              fontFamily: 'Nunito',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10.0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12), // <-- Radius
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Review',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                //Sent widgets --------------------------------------------------------------------------------------------------------------------
                _isLoading
                    ? Loading()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: sentLength,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 110.0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 60, 44, 167),
                                    Colors.deepOrange
                                  ],
                                ),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.elliptical(2, 3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Color.fromARGB(239, 30, 43, 66),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${challenges![index].quizName} quiz challenge sent.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito')),
                                        Text(
                                            'Date sent: ${challenges![index].dateSent}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito')),
                                        Text(
                                            'Challenge status: ${challenges![index].challengeStatus}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito')),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ]),
            ),
    );
  }
}
// coverage:ignore-end
