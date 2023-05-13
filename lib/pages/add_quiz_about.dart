// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// coverage:ignore-start
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../shared/loading.dart';
import 'add_questions.dart';
import '../classes/qa_container.dart';
import 'home.dart';
import '../services/database.dart';

class AddQuiz extends StatefulWidget {
  final _aboutQuizController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final OurUser user;

  AddQuiz({super.key, required this.user});
  @override
  State<AddQuiz> createState() => AddQuizState();
}

class AddQuizState extends State<AddQuiz> {
  List<QAContainer> qaContainers = [];
  List? categories = [];
  String _selectedCategory = 'Art';
  DatabaseService service = DatabaseService();
  int currentIndex = 0;
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

  // screens for stacked widget
  List<Widget> screens = [];

  late bool _isLoading;

  // before obtaining category data from database, add loading screen
  // after obtaining category data from database, set loading to false
  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    categories = await service.getCategories();
    currentUser = await service.getUser(widget.user.uid);
    // categories = categoriesDynamic?.map((e) => e.toString()).toList();
    setState(() {
      _isLoading = false;
    });
  }

  // load category data on screen initialization
  @override
  void initState() {
    loaddata();
    super.initState();
    _selectedCategory = 'Art';
    // screens = [
    //   Home(
    //     user: widget.user,
    //   ),
    //   Profile(user: widget.user)
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // if isLoading is true, return nothing else if isLoading is false display appbar
      appBar: _isLoading
          ? null
          : AppBar(
              title: const Text(
                'Quiz Creator',
                style: TextStyle(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(user: widget.user),
                      ));
                },
              ),
            ),
      // prevent renderflex overflow error just in case
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 27, 57, 82),
              Color.fromARGB(255, 5, 12, 31),
            ],
          ),
        ),
        // if isLoading is false, display circular progress widget for loading screen else display child of body
        child: SafeArea(
          child: _isLoading
              ? Loading()
              //after data is loaded this displays
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 45, 64, 96),
                                Color.fromARGB(255, 45, 64, 96),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextField(
                                  controller: widget._titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Add Title',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                  ),
                                  controller: widget._aboutQuizController,
                                  minLines: 5,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    labelText: 'About',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Nonita',
                                      color: Colors.grey,
                                    ),
                                    hintText: 'About',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Nonita',
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Center(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: _selectedCategory,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _selectedCategory =
                                              newValue as String;
                                        },
                                      );
                                    },
                                    items: categories?.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category,
                                            style: TextStyle(
                                                fontFamily: 'Nunito')),
                                      );
                                    }).toList(),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 20.0,
                                    ),
                                    iconEnabledColor: Colors.white, //Icon color
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors
                                          .white, //Font color //font size on dropdown button
                                    ),
                                    dropdownColor:
                                        Color.fromARGB(255, 45, 64, 96),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 60.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddQuestions(
                                      aboutQuiz:
                                          widget._aboutQuizController.text,
                                      category: _selectedCategory,
                                      title: widget._titleController.text,
                                      user: widget.user,
                                      currentUser: currentUser)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Begin adding questions',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
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

// coverage:ignore-end