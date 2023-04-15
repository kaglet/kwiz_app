import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import '../models/quizzes.dart';
import 'home.dart';
// import 'start_quiz.dart';
import '../services/database.dart';

class Bookmark extends StatefulWidget {
  final String chosenCategory;
  const Bookmark({super.key, required this.chosenCategory});

  @override
  // ignore: library_private_types_in_public_api
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  late String categoryName;
  DatabaseService service = DatabaseService();
  List<Quiz>? categoryQuiz;
  List<Quiz>? filteredQuizzes;

  @override
  void initState() {
    super.initState();
    categoryName = widget.chosenCategory;
    loadData().then((value) {
      setState(() {});
    });
  }

  int filLength = 0;

  // loads data from DB
  Future<void> loadData() async {
    if (categoryName == 'All') {
      categoryQuiz = await service.getAllQuizzes();
    } else {
      categoryQuiz = await service.getQuizByCategory(category: categoryName);
    }

    filteredQuizzes = List<Quiz>.from(categoryQuiz!);
    filLength = filteredQuizzes!.length;
  }

  final TextEditingController _searchController = TextEditingController();

// This function is used to filter the quizzes by doing a linear search of the quizzes retrieved from the database,
// it is moved to normal lists first as this caused issues
  void filterQuizzes(String searchTerm) {
    setState(() {
      filteredQuizzes = List<Quiz>.from(categoryQuiz!);
      List<String> quizzesNames = [];
      List<String> filteredQuizzesNames = [];

      for (int i = 0; i < filLength; i++) {
        quizzesNames.add(categoryQuiz!.elementAt(i).quizName);
      }

      filteredQuizzesNames = quizzesNames
          .where(
              (quiz) => quiz.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      if (filteredQuizzesNames.isNotEmpty) {
        filteredQuizzes!.clear();
        for (int j = 0; j < filteredQuizzesNames.length; j++) {
          for (int k = 0; k < filLength; k++) {
            if (filteredQuizzesNames[j] ==
                categoryQuiz!.elementAt(k).quizName) {
              filteredQuizzes!.add(categoryQuiz!.elementAt(k));
            }
          }
        }
      } else {
        filteredQuizzes = List<Quiz>.from(categoryQuiz!);
      }

      filLength = filteredQuizzesNames.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Quizzes',
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
                MaterialPageRoute(builder: (context) => const Home()),
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
                      filterQuizzes(_searchController.text);
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
                  filterQuizzes(value);
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                  ),
                  filteredQuizzes == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: filLength,
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
                                    filteredQuizzes!.elementAt(index).quizName,
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
                                          filteredQuizzes!
                                              .elementAt(index)
                                              .quizCategory,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          filteredQuizzes!
                                              .elementAt(index)
                                              .quizDateCreated,
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
                                          const Color.fromARGB(
                                              255, 59, 98, 172),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StartQuiz(
                                                chosenQuiz: filteredQuizzes!
                                                    .elementAt(index)
                                                    .quizID),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .transparent, // remove button background color
                                        elevation: 0, // remove button shadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
