import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/add_quiz_about.dart';
import 'package:kwiz_v2/pages/profile.dart';
import 'package:kwiz_v2/pages/view_categories.dart';
import 'package:kwiz_v2/services/database.dart';
import '../services/auth.dart';
// import 'add_quiz_about.dart';
// import 'view_categories.dart';

class Home extends StatefulWidget {
  final OurUser user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  // return static home screen with navigation functionality //
  final AuthService _auth = AuthService();
  DatabaseService service = DatabaseService();

  UserData? currentUser = UserData(
      uID: ' ',
      userName: ' ',
      firstName: ' ',
      lastName: ' ',
      bookmarkedQuizzes: [],
      pastAttemptQuizzes: []);
  late bool _isLoading;

  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    currentUser = await service.getUser(widget.user.uid);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            //after data is loaded this displays
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 250.0,
                              height: 70.0,
                              child: Text(
                                currentUser!.userName,
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
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Profile(user: widget.user)),
                                );
                              },
                            ),
                          ]),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(46, 46, 50, 0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: const Center(
                                child: Text(
                                  'What would you like to do?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 150.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCategories(
                                                      user: widget.user)),
                                        );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color.fromARGB(
                                                    255, 230, 131, 44),
                                                Color.fromARGB(
                                                    255, 244, 112, 72),
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
                                    height: 150.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddQuiz(
                                                    user: widget.user,
                                                  )),
                                        );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color.fromARGB(
                                                    255, 222, 127, 43),
                                                Color.fromARGB(
                                                    255, 246, 120, 82),
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
