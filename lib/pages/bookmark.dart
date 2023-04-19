import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import '../models/quizzes.dart';
import 'home.dart';
// import 'start_quiz.dart';
import '../services/database.dart';

class Bookmark extends StatefulWidget {
  final OurUser user;
  //final String chosenCategory;
  const Bookmark({super.key,  required this.user, required String userID});

  @override
  // ignore: library_private_types_in_public_api
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  late String categoryName;
  DatabaseService service = DatabaseService();
  List? bmQuizzes = [];
  List? bmList = [];
  int bmQuizzesLength = 0;
  UserData? userData;
  List? _displayedItems = [];
  
  @override
  void initState() {
    super.initState();
    _displayedItems = bmQuizzes;
    loadData().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int catLength = 0;
  int fillLength = 0;
  // loads data from DB
  Future<void> loadData() async {
    userData = await service.getUserAndBookmarks(userID: 'TNaCcDwiABgchtIZKjURlYjimPG2');
    bmList = userData!.bookmarkedQuizzes;
    bmQuizzesLength = bmQuizzes!.length;

    for (int i = 0; i < bmQuizzesLength; i++) {
      bmQuizzes!.add(bmList?[i].toString());
      /*marks!.add(pastAttemptsObject?[i].pastAttemptQuizMarks);
      quizID!.add(pastAttemptsObject?[i].pastAttemptQuizID.toString());
      quizName!.add(pastAttemptsObject?[i].pastAttemptQuizName.toString());
      dates!.add(pastAttemptsObject?[i].pastAttemptQuizDatesAttempted); */

    }
    _displayedItems = bmQuizzes;
    fillLength = _displayedItems!.length;
    print("HERE");
    print(bmQuizzes);
  }

  final TextEditingController _searchController = TextEditingController();

// This function is used to filter the quizzes by doing a linear search of the quizzes retrieved from the database,
// it is moved to normal lists first as this caused issues
  // void filterQuizzes(String searchTerm) {
  //   setState(() {
  //     filteredQuizzes = List<Quiz>.from(categoryQuiz!);
  //     List<String> quizzesNames = [];
  //     List<String> filteredQuizzesNames = [];

  //     for (int i = 0; i < catLength; i++) {
  //       quizzesNames.add(categoryQuiz!.elementAt(i).quizName);
  //     }

  //     filteredQuizzesNames = quizzesNames
  //         .where(
  //             (quiz) => quiz.toLowerCase().contains(searchTerm.toLowerCase()))
  //         .toList();

  //     if (filteredQuizzesNames.isNotEmpty) {
  //       filteredQuizzes!.clear();
  //       for (int j = 0; j < filteredQuizzesNames.length; j++) {
  //         for (int k = 0; k < catLength; k++) {
  //           if (filteredQuizzesNames[j] ==
  //               categoryQuiz!.elementAt(k).quizName) {
  //             filteredQuizzes!.add(categoryQuiz!.elementAt(k));
  //           }
  //         }
  //       }
  //     } else {
  //       filteredQuizzes = List<Quiz>.from(categoryQuiz!);
  //     }

  //     filLength = filteredQuizzesNames.length;
  //   });
  // }

  void _onSearchTextChanged(String text) {
    setState(() {
      _displayedItems = bmQuizzes!
          .where((item) => item.toLowerCase().contains(text.toLowerCase()))
          .toList();
      fillLength = _displayedItems!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Bookmarked Quizzes',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: 'TitanOne',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.category),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(user: widget.user)),
              );
            },
          ),
        ],
      ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 45, 64,
                      96), // set the background color to a darker grey
                  hintText: 'Search bookmarked quizzes',
                  hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily:
                        'Nunito', // set the hint text color to a light grey
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color.fromRGBO(192, 192, 192,
                        1), // set the search icon color to a light grey
                    onPressed: () {
                      //filterQuizzes(_searchController.text);
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(81, 95, 87,
                            1)), // set the border color to a darker grey
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors
                            .white), // set the focused border color to white
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: (value) {
                  //filterQuizzes(value);
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                  ),
                  bmQuizzes == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: fillLength,
                          itemBuilder: (context, index) {
                            final List<Color> blueAndOrangeShades = [
                              Colors.orange.shade400,
                              Colors.orange.shade500,
                              Colors.orange.shade600,
                              Colors.orange.shade700,
                            ];

                            final Color color1 = blueAndOrangeShades[
                                index % blueAndOrangeShades.length];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: color1,
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
                                color: const Color.fromARGB(240, 45, 64, 96),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Text(
                                    bmQuizzes!.elementAt(index).quizName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Author: (TBA)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                         bmQuizzes!.elementAt(index).QuizID,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                         bmQuizzes!.elementAt(index),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          color1,
                                          const Color.fromARGB(255, 59, 98, 172),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => StartQuiz(
                                        //         user: widget.user,
                                        //         chosenQuiz: filteredQuizzes!
                                        //             .elementAt(index)
                                        //             .quizID),
                                        //   ),
                                        // );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Start Quiz',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            );
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
