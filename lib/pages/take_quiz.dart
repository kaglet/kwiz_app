
import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/quiz_score.dart';
import '../services/database.dart';
import '../models/quizzes.dart';

class QuizScreen extends StatefulWidget {
  final String qID;
  const QuizScreen(this.qID, {super.key});
  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  //final String qID = widget.qID;
  DatabaseService service = DatabaseService();
  // Get the questions from firebase
  late bool _isLoading;
  int quizLength = 0;
  Quiz? quiz;

  List<String> userAnswers = [];

  //Getting quiz, length of quiz and populating quiz questions and answers
  Future<void> loaddata() async {
    setState(() {
      _isLoading = true;
    });
    quiz = await service.getQuizAndQuestions(quizID: widget.qID);
    quizLength =
        quiz!.quizQuestions.length; //this seemed to have fixed the null error?
    userAnswers = List.filled(quizLength, '');
    category = quiz!.quizCategory.toString();
    popList(quiz);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  //function for populating the questions and answers
  void popList(Quiz? q) {
    for (int i = 0; i < quizLength; i++) {
      questions.add(q!.quizQuestions.elementAt(i).questionText);
      answers.add(q.quizQuestions.elementAt(i).questionAnswer);
    }
  }

  //Two local var lists for storing answers and questions
  List<String> questions = [];
  List<String> answers = [];

  // Controller for the answer input field
  TextEditingController answerController = TextEditingController();

  //get quizname from firebase
  final String quizName = 'PlaceHolder :)';

  String category = "";

  // Index of the current question
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void updateText() {
      answerController.text = userAnswers[currentIndex];
    }

    //load before data comes then display ui after data is recieved
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text(
                quiz!.quizName,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'TitanOne',
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 27, 57, 82),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Center(
                              child: Image.asset(
                            'assets/images/$category.gif',
                          ))),

                      // Display the question number and question text
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Question ${currentIndex + 1} of ${questions.length}', //
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      Text(
                        questions[currentIndex],
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Input field for the answer

                      TextField(
                        controller: answerController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type your answer here',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 126, 125, 125),
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),

                      const SizedBox(height: 32.0),

                      // Buttons for moving to the previous/next question

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentIndex > 0)
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.blue, Colors.blue],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentIndex--;
                                    updateText();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  backgroundColor: Colors
                                      .transparent, // set the button background color to transparent
                                  elevation: 0, // remove the button shadow
                                ),
                                child: const Text(
                                  'Previous',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ),

                          if (currentIndex < questions.length - 1)
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.orange, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  userAnswers[currentIndex] =
                                      answerController.text.trim();
                                  setState(() {
                                    currentIndex++;
                                    updateText();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  backgroundColor: Colors
                                      .transparent, // set the button background color to transparent
                                  elevation: 0, // remove the button shadow
                                ),
                                child: const Text(
                                  '  Next  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ),

                          // Show a submit button on the last question
                          if (currentIndex == questions.length - 1)
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Calculate the score
                                  userAnswers[currentIndex] =
                                      answerController.text.trim();

                                  if (userAnswers.contains('')) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Missing answers'),
                                          content: const Text(
                                              'Please fill in an answer for each question'),
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
                                    int score = 0;
                                    for (int i = 0; i < questions.length; i++) {
                                      if (userAnswers[i].toLowerCase() ==
                                          answers[i].toLowerCase()) {
                                        score++;
                                        //print(answerController.text);
                                      }
                                    }
                                    // Show the score in an alert dialog

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Quiz Complete'),
                                          content: const Text(
                                              'Are you sure you are ready to submit?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuizScore(chosenQuiz: quiz!.quizID, score: score, userAnswers: userAnswers)),
                                                );
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  backgroundColor: Colors
                                      .transparent, // set the button background color to transparent
                                  elevation: 0, // remove the button shadow
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// //USE WIDGET INSPECTOR type Ctrl + T and search >Dart: Open DevTools
// //Flex makes it "become small" can be squashed :) the picture of the globe is squashed when we click on input box.

// /*PROBLEMS:
//         >> [SOLVED :D] texteditingcontroller is the same for all questions.
//                 ...do i create new tec for each question?
//         >> [SOLVED :D] want text to remain when i press previous but only one answer saved?????
//         >> [SOLVED] having trouble adding comparing userAnswers and answer lists.
//         >> [SOLVED] set flex for picture perma

// */

// //add the data pulled into a list and work with the list instead
