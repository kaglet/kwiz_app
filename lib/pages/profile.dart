// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/bookmark.dart';
import 'package:kwiz_v2/pages/quiz_history.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'package:kwiz_v2/models/user.dart';

class Profile extends StatefulWidget {
  final OurUser user;
  //final VoidCallback onClose;
  final AnimationController controller;
  final void Function(bool) onOverlayClose;
  const Profile(
      {super.key,
      required this.user,
      required this.controller,
      required this.onOverlayClose});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;
  late void Function(bool) onOverlayClose;
  List? quizzes = [];
  DatabaseService service = DatabaseService();
  late final OverlayEntry overlayEntry;
  late final AnimationController controller;
  final AuthService _auth = AuthService();

  UserData? currentUser = UserData(
      uID: ' ',
      userName: ' ',
      firstName: ' ',
      lastName: ' ',
      bookmarkedQuizzes: [],
      pastAttemptQuizzes: []);

  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    quizzes = await service.getCategories();
    currentUser = await service.getUser(widget.user.uid);
    // categories = categoriesDynamic?.map((e) => e.toString()).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loaddata();
    super.initState();
    controller = widget.controller;
    onOverlayClose = widget.onOverlayClose;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 280,
      child: Scaffold(
        appBar: _isLoading
            ? AppBar(
                toolbarHeight: 60,
                title: const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'TitanOne',
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 27, 57, 82),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // overlayEntry.remove();
                    }, // call the callback function here
                  ),
                ],
              )
            : AppBar(
                toolbarHeight: 60,
                title: const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'TitanOne',
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 27, 57, 82),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onOverlayClose(false);

                      controller.reverse();
                      // overlayEntry.remove();
                    }, // call the callback function here
                  ),
                ],
              ),

        // prevent renderflex overflow error just in case
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
                  const SizedBox(
                    height: 40.0,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_pin,
                      color: Colors.white,
                      size: 90.0,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              Text(
                                currentUser!.userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${currentUser!.firstName} ${currentUser!.lastName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            // const Text(
                            //   'email',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 18.0,
                            //     fontWeight: FontWeight.w600,
                            //     letterSpacing: 1.0,
                            //     fontFamily: 'Nunito',
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(46, 46, 50, 0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 70.0,
                                child: GestureDetector(
                                  onTap: () {
                                    onOverlayClose(false);
                                    controller.reverse();
                                    //   overlayEntry.remove();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuizHistory(user: widget.user)),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
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
                                          'Past Quizzes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
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
                          height: 60.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 70.0,
                                child: GestureDetector(
                                  onTap: () {
                                    onOverlayClose(false);
                                    controller.reverse();
                                    //  overlayEntry.remove();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Bookmark(user: widget.user)),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
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
                                          'Bookmarks',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
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
                          height: 90.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50.0,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.reverse();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            Navigator.of(context).pop();
                                            return true;
                                          },
                                          child: AlertDialog(
                                            backgroundColor: Colors
                                                .transparent, // Set the background color to transparent
                                            contentPadding: EdgeInsets.zero,
                                            content: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 27, 57, 82),
                                                    Color.fromARGB(
                                                        255, 11, 26, 68),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Log out',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      letterSpacing: 1.0,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  const Text(
                                                    'Are you sure you want to log out?',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.0,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          controller.forward();
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Colors.blue,
                                                                Colors.blue,
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      10.0,
                                                                  horizontal:
                                                                      20.0),
                                                          child: const Text(
                                                            'Back',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.0,
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
                                                      const SizedBox(
                                                          width: 50.0),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          controller.reverse();
                                                          await _auth.signOut();
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Color.fromARGB(
                                                                    255,
                                                                    222,
                                                                    127,
                                                                    43),
                                                                Color.fromARGB(
                                                                    255,
                                                                    246,
                                                                    120,
                                                                    82),
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      10.0,
                                                                  horizontal:
                                                                      20.0),
                                                          child: const Text(
                                                            ' Ok ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.0,
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
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 43, 186, 222),
                                            Color.fromARGB(255, 82, 112, 246),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Log out',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
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
      ),
    );
  }
}

// coverage:ignore-end