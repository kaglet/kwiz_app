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
  DatabaseService service = DatabaseService();
  int currentIndex = 0;
  bool _isLoading = false;

  // load before adding quiz with questions data to database, and complete loading once done, then navigate to next screen
  Future<void> addData(Quiz quiz) async {
    setState(() {
      _isLoading = true;
    });
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                user: widget.user,
                              )),
                    );
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
                                  // coverage:ignore-end
                                  Quiz quiz =
                                      createQuizFromContainers(qaContainers);
                                  addData(quiz);
                                  // coverage:ignore-start
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
                                  String qaType = 'trueOrFalse';
                                  qaContainers.add(QAContainer(
                                      qaType: qaType,
                                      // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                      // a key is passed in as a parameterwhich  is the unique key of the widget
                                      delete: (key) {
                                        setState(() {
                                          qaContainers.removeWhere(
                                              (QAContainer) =>
                                                  QAContainer.key == key);
                                        });
                                      },
                                      key: uniqueKey));
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
      }
      else{
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
        quizAuthor: widget.currentUser!.userName);
    return quiz;
  }
}

// coverage:ignore-end