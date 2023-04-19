import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/add_quiz_about.dart';
import 'package:kwiz_v2/pages/quiz_history.dart';
import 'package:kwiz_v2/pages/view_categories.dart';
import '../services/database.dart';
import 'package:kwiz_v2/models/user.dart';

class Profile extends StatefulWidget {
  final OurUser user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;
  List? quizzes = [];
  DatabaseService service = DatabaseService();

  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    quizzes = await service.getCategories();
    // categories = categoriesDynamic?.map((e) => e.toString()).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'TitanOne',
                ),
              ),
              backgroundColor: Color.fromARGB(255, 27, 57, 82),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {},
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
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Text(
                          'My Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                            fontFamily: 'TitanOne',
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('username'),
                        Text('email'),
                        Text('etc'),
                      ]),
                      SizedBox(
                        width: 30.0,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80.0,
                        ),
                        onPressed: () {},
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
                                            QuizHistory(user: widget.user)),
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
                                        'Past Quizzes',
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
                                        'Bookmarked quizzes',
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
