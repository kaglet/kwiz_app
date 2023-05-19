// ignore_for_file: prefer_const_constructors
// coverage:ignore-start
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../classes/qa_obj.dart';
import '../classes/qa_container.dart';
import '../models/questions.dart';
import '../models/quizzes.dart';
import 'home.dart';
import '../services/database.dart';

class AddQuestions extends StatefulWidget {
  final String category;
  final String title;
  final String aboutQuiz;
  final OurUser user;
  final UserData? currentUser;

  const AddQuestions(
      {super.key,
      required this.aboutQuiz,
      required this.title,
      required this.category,
      required this.user,
      required this.currentUser});

  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  List<QAContainer> qaContainers = [];
  List<Question> savedQAs = [];
  // DatabaseService service = DatabaseService();
  int currentIndex = 0;
  bool _isLoading = false;
  String? _selectedQuestionType;

  bool checkIfQuestionsAreFilled(Quiz quiz) {
    // how can it check when its not always created, well just check if not null
    bool boolean = true;
    print(quiz.quizQuestions.length);
    for (var i = 0; i < quiz.quizQuestions.length; i++) {
      print(quiz.quizQuestions.elementAt(i).questionText);
      print(quiz.quizQuestions.elementAt(i).questionAnswer);
      if (quiz.quizQuestions.elementAt(i).questionText == '' ||
          quiz.quizQuestions.elementAt(i).questionAnswer == '') {
        return false;
      }
    }
    return boolean;
  }

  List? questionOptions = [
    "trueOrFalse",
    "fillInTheBlank",
    "shortAnswer",
    "multipleChoice",
    "dropdown",
    "ranking"
  ];

  // load before adding quiz with questions data to database, and complete loading once done, then navigate to next screen
  Future<void> addData(Quiz quiz) async {
    setState(() {
      _isLoading = true;
    });
    DatabaseService service = DatabaseService();
    await service.addQuizWithQuestions(quiz);
    setState(() {
      _isLoading = false;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // if isLoading is true, return nothing else if isLoading is false display appbar
      appBar: _isLoading
          ? null
          : AppBar(
              title: const Text(
                'Add Questions',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'TitanOne',
                ),
              ),
              backgroundColor: Color.fromARGB(255, 27, 57, 82),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement category filter
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
      // prevent renderflex overflow error just in case
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
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
                                  // clear qaContainer widgets from screen
                                  setState(() {
                                    qaContainers.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.all(12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  'Start over',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Quiz quiz =
                                      createQuizFromContainers(qaContainers);
                                  if (checkIfQuestionsAreFilled(quiz) ==
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Quiz questions and/or answers not filled in'),
                                          content: const Text(
                                              'Please fill in all the questions and answers for this quiz.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    addData(quiz);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.all(12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: qaContainers.length,
                          itemBuilder: (context, index) {
                            // with each index return qaContainer at that index into listview with adjusted question number
                            qaContainers.elementAt(index).number = index + 1;
                            return qaContainers.elementAt(index);
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                setState(() {
                                  final uniqueKey = UniqueKey();
                                  _selectedQuestionType = null;

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
                                                  'Select Question Type',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    letterSpacing: 1.0,
                                                    fontFamily: 'Nunito',
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                DropdownButton(
                                                  isExpanded: false,
                                                  value: _selectedQuestionType,
                                                  onChanged: (newValue) {
                                                    setState(
                                                      () {
                                                        _selectedQuestionType =
                                                            newValue as String;
                                                        String qaType =
                                                            _selectedQuestionType!;
                                                        // String qaType = 'trueOrFalse';
                                                        qaContainers.add(QAContainer(
                                                            qaType: qaType,
                                                            // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                                            // a key is passed in as a parameterwhich  is the unique key of the widget
                                                            delete: (key) {
                                                              setState(() {
                                                                qaContainers.removeWhere(
                                                                    (QAContainer) =>
                                                                        QAContainer
                                                                            .key ==
                                                                        key);
                                                              });
                                                            },
                                                            key: uniqueKey));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    );
                                                  },
                                                  hint: Text(
                                                      'Select Question Type',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  items: questionOptions
                                                      ?.map((option) {
                                                    String displayText = '';
                                                    if (option ==
                                                        'trueOrFalse') {
                                                      displayText =
                                                          'True Or False';
                                                    } else if (option ==
                                                        'fillInTheBlank') {
                                                      displayText =
                                                          'Fill in the Blank';
                                                    } else if (option ==
                                                        'shortAnswer') {
                                                      displayText =
                                                          'Short Answer';
                                                    } else if (option ==
                                                        'multipleChoice') {
                                                      displayText =
                                                          'Multiple Choice';
                                                    } else if (option ==
                                                        'ranking') {
                                                      displayText = 'Ranking';
                                                    } else if (option ==
                                                        'dropdown') {
                                                      displayText = 'Dropdown';
                                                    }
                                                    return DropdownMenuItem(
                                                      value: option,
                                                      child: Text(displayText,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Nunito')),
                                                    );
                                                  }).toList(),

                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 20.0,
                                                  ),
                                                  iconEnabledColor:
                                                      Colors.white, //Icon color
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: Colors
                                                        .white, //Font color //font size on dropdown button
                                                  ),
                                                  dropdownColor: Color.fromARGB(
                                                      255, 45, 64, 96),
                                                ),
                                                const SizedBox(height: 15.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
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
                                                    ),
                                                    const SizedBox(width: 50.0),
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

                                  // String qaType = 'trueOrFalse';

                                  // qaContainers.add(QAContainer(
                                  //     qaType: qaType,
                                  //     // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                  //     // a key is passed in as a parameterwhich  is the unique key of the widget
                                  //     delete: (key) {
                                  //       setState(() {
                                  //         qaContainers.removeWhere(
                                  //             (QAContainer) =>
                                  //                 QAContainer.key == key);
                                  //       });
                                  //     },
                                  //     key: uniqueKey));
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                              child: Text(
                                'Add Question',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Quiz createQuizFromContainers(List<QAContainer> qaContainers) {
    // convert each qaContainer to questionObj data that can be added to a list
    int i = 1;

    for (var qaContainer in qaContainers) {
      // extract QA data in qaContainer into a useable object form
      QA qa = qaContainer.extractQA();
      if (qa is QAMultiple) {
        MultipleAnswerQuestion questionObj = MultipleAnswerQuestion(
            questionNumber: i,
            questionText: qa.question,
            questionAnswer: qa.answer,
            questionMark: 0,
            questionType: qa.type,
            answerOptions: qa.answerOptions);
        savedQAs.add(questionObj);
        i++;
      } else {
        Question questionObj = Question(
            questionNumber: i,
            questionText: qa.question,
            questionAnswer: qa.answer,
            questionMark: 0,
            questionType: qa.type);
        savedQAs.add(questionObj);
        i++;
      }
    }
    // add about quiz data sent from previous page and questions list to quiz object
    Quiz quiz = Quiz(
        quizName: widget.title,
        quizCategory: widget.category,
        quizDescription: widget.aboutQuiz,
        quizMark: savedQAs.length,
        quizDateCreated: DateTime.now().toString().substring(0, 16),
        quizQuestions: savedQAs,
        // quizAuthorID: widget.user.uid,
        quizID: '',
        quizGlobalRating: 0,
        quizTotalRatings: 0,
        quizAuthor: widget.currentUser!.userName);
    return quiz;
  }
}

// coverage:ignore-end