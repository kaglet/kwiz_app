// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/quiz_score.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../models/questions.dart';
import '../services/database.dart';
import '../models/quizzes.dart';

class QuizScreen extends StatefulWidget {
  final OurUser user;
  final String qID;
  const QuizScreen(this.qID, {super.key, required this.user});
  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  //final String qID = widget.qID;
  DatabaseService service = DatabaseService();
  // Get the questions from firebase
  late bool _isLoading = true;
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
        quiz!.quizQuestions.length;
    print("quiz here" );
    print(quizLength);

    answerOptionsMC = List<List<String>>.generate(quizLength,
        (index) => List<String>.filled(10, ""),
        );    //filling the quiz with quiz length number of lists
        answerOptionsDD = List<List<String>>.generate(quizLength,
        (index) => List<String>.filled(10, ""),
        );
        answerOptionsR = List<List<String>>.generate(quizLength,
        (index) => List<String>.filled(10, ""),
        );

    for (var question in quiz!.quizQuestions) {
      if (question is MultipleAnswerQuestion) {
        
        //print(answerOptionsMC);

        // for (int i = 0; i < quizLength; i++) {
        //   answerOptionsMC[i] = List.filled(quizLength, "");   //filling the inner list with empty string 
        //   answerOptionsDD[i] = List.filled(quizLength, "");   //WRONG not quizlength use number of 
        //   answerOptionsR[i] = List.filled(quizLength, "");
        // }
        // print(answerOptionsMC);

        print(question.questionNumber -1);

        if (question.questionType == "multipleChoice"){
          answerOptionsMC[question.questionNumber-1] = question.answerOptions;
          print(answerOptionsMC);
          // print(question.questionNumber);
          // print(question.answerOptions);
          // print(question.questionType);
        }

        if (question.questionType == "dropdown"){
          answerOptionsDD[question.questionNumber-1] = question.answerOptions; 
          print(answerOptionsDD) ;  
        }

        if (question.questionType == "ranking"){
          answerOptionsR[question.questionNumber-1] = question.answerOptions; 
          print(answerOptionsR) ;  
        }
      }
    }

    //quiz = await service.getQuizAndQuestions(quizID: widget.qID);
    // quizLength =
    //     quiz!.quizQuestions.length; //this seemed to have fixed the null error?
    userAnswers = List.filled(quizLength, '');
    category = quiz!.quizCategory.toString();
    //popList(quiz);
    List<String> quest = [];
    List<String> ans = [];
    questions = popQuestionsList(quiz, quest, ans);
    answers = popAnswersList(quiz, quest, ans);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  // void popList(Quiz? q) {
  //   for (int i = 0; i < quizLength; i++) {
  //     questions.add(q!.quizQuestions.elementAt(i).questionText);
  //     answers.add(q.quizQuestions.elementAt(i).questionAnswer);
  //   }
  // }

// coverage:ignore-end
  //function for populating the questions and answers
  List<String> popQuestionsList(Quiz? q, List<String> quest, List<String> ans) {
    for (int i = 0; i < quizLength; i++) {
      quest.add(q!.quizQuestions.elementAt(i).questionText);
    }
    return quest;
  }

  List<String> popAnswersList(Quiz? q, List<String> quest, List<String> ans) {
    for (int i = 0; i < quizLength; i++) {
      ans.add(q!.quizQuestions.elementAt(i).questionAnswer);
    }
    return ans;
  }

// coverage:ignore-start
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

  String currentQuestionType = "";

  //split list for fill in the blank questions
  List<String> questionParts = [];

  //lists for one instance of MC and dropdown and ranking  create list of list for multiple MC and dropdown later
  List<List<String>> answerOptionsMC = [];
  List<List<String>> answerOptionsDD = [];
  List<List<String>> answerOptionsR = [];

  @override
  Widget build(BuildContext context) {
    void updateText() {
      answerController.text = userAnswers[currentIndex];
    }

    if (_isLoading == false){
      currentQuestionType = quiz!.quizQuestions[currentIndex].questionType;
    }
      
    print(currentQuestionType);   
    //load before data comes then display ui after data is recieved
    return _isLoading
            ? Loading() 
            :Scaffold(
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
        child: /*const Center(
                child: CircularProgressIndicator(),
              )*/
            //after data is loaded this displays
             Container(
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
                      // Flexible(
                      //     flex: 1,
                      //     fit: FlexFit.tight,
                      //     child: Center(
                      //         child: Image.asset(
                      //       'assets/images/$category.gif',
                      //     ))),

                      // Display the question number and question text
                      const SizedBox(
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

                      if (currentQuestionType == "shortAnswer")
                        Column(
                          children: [
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
                          ],
                        ),

                      if (currentQuestionType == "trueOrFalse")
                        Column(
                          children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                        answerController.text = 'False';
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
                                      'False',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ),
                                ),
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
                                      setState(() {
                                        answerController.text = 'True';
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
                                      'True',
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
                            const SizedBox(height: 32.0),
                            Text(
                              answerController.text.isEmpty
                                  ? "Select an option"
                                  : "You have selected: ${answerController.text}",
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(height: 32.0),
                          ],
                        ),

                      if (currentQuestionType == "multipleChoice")
                        SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              // Display the question number and question text
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

                              // Display the answer options
                              Expanded(
                                child: ListView.builder(
                                  itemCount: answerOptionsMC[currentIndex].length,
                                  itemBuilder: (BuildContext context, int index) {
                                    bool isSelected = answerController.text == answerOptionsMC[currentIndex][index];
                                    print("How to access?????");
                                    print(answerOptionsMC[currentIndex]);
                                    return ListTile(
                                      title: Text(
                                        answerOptionsMC[currentIndex][index],
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.grey, // Adjust the colors as needed
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      tileColor: isSelected ? Colors.green : null, // Adjust the highlight color as needed
                                      onTap: () {
                                        // Handle the selected answer
                                        setState(() {
                                          answerController.text = answerOptionsMC[currentIndex][index];
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32.0),
                            ],
                          ),
                        ),
                      


                      if (currentQuestionType == "dropdown")
                        SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              // Display the question number and question text
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

                              // Display the dropdown button
                              DropdownButtonFormField(
                                isExpanded: false,
                                value: answerController.text.isNotEmpty ? answerController.text : null,
                                items: answerOptionsDD[currentIndex].map<DropdownMenuItem<String>>((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  // Handle the selected answer
                                  setState(() {
                                    answerController.text = newValue ?? "";
                                  });
                                },  icon: Icon(
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
                                      hint: Text(
                                    'Select an option',
                                    style: TextStyle(
                                        color: Colors.white)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:Color.fromARGB(
                                    255, 45, 64, 96),
                                  
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color.fromARGB(
                                    255, 45, 64, 96)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32.0),
                            ],
                          ),
                        ),

                      if (currentQuestionType == "ranking")
                        SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              // Display the question number and question text
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

                              // Display the answer options as draggable tiles
                              Expanded(
                                child: ReorderableListView(
                                  onReorder: (oldIndex, newIndex) {
                                    // Reorder the list of answer options
                                    setState(() {
                                      if (newIndex > oldIndex) {
                                        newIndex -= 1;
                                      }
                                      final String item = answerOptionsR[currentIndex].removeAt(oldIndex);
                                      answerOptionsR[currentIndex].insert(newIndex, item);
                                    });
                                  },
                                  children: answerOptionsR[currentIndex]
                                    .map((option) => ListTile(
                                      key: ValueKey(option), // Set a unique key for each ListTile
                                      title: Text(
                                        option,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      leading: Icon(
                                        Icons.drag_handle,
                                        color: Colors.white,
                                      ),
                                    ))
                                    .toList(),
                                ),
                              ),
                              const SizedBox(height: 32.0),

                              ElevatedButton(
                                onPressed: () {
                                  print(answerOptionsR);
                                  answerController.text = answerOptionsR[currentIndex]
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .replaceAll(' ', '')
                                      .replaceAll('\n', '');
                                  print(answerController.text);
                                  int diff = answerController.text
                                      .compareTo(answers[currentIndex]);
                                  print("the difference: $diff");
                                  setState(() {
                                    //currentIndex--;
                                    //updateText();
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
                                  'Save Answer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),

                              // Display the text field for adding new answer options
                              // TextField(
                              //   controller: answerController,
                              //   onChanged: (value) {
                              //     // Update the answer text every time the user types or edits the text field
                              //     setState(() {
                              //       answerController.text = value;
                              //     });
                              //   },
                              //   onSubmitted: (value) {
                              //     // Add the new answer option to the list of answer options
                              //     setState(() {
                              //       answerOptionsR.add(value);
                              //       answerController.clear();
                              //     });
                              //   },
                              //   decoration: InputDecoration(
                              //     hintText: 'Add an answer option',
                              //     hintStyle: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'Nunito',
                              //     ),
                              //   ),
                              //   style: const TextStyle(
                              //     color: Colors.white,
                              //     fontFamily: 'Nunito',
                              //   ),
                              // ),
                            ],
                          ),
                        ),


                      if (currentQuestionType == "fillInTheBlank")
                        Column(
                          children: [
                            Text(
                              questions[currentIndex].substring(
                                  0,
                                  questions[currentIndex]
                                      .indexOf("**")), //gets string before **
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(height: 32.0),
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
                            Text(
                              questions[currentIndex].substring(
                                  questions[currentIndex].indexOf("**") +
                                      2), //gets string after **
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(height: 32.0),
                          ],
                        ),

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
                                  userAnswers[currentIndex] =
                                      answerController.text.trim();
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
                                  print(userAnswers);
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
                                                    'Submit quiz',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      letterSpacing: 1.0,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  const Text(
                                                    '   Are you sure you want to submit your quiz?   ',
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
                                                      const SizedBox(
                                                          width: 50.0),
                                                      TextButton(
                                                        onPressed: () {
                                                          print(answers);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => QuizScore(
                                                                    user: widget
                                                                        .user,
                                                                    chosenQuiz:
                                                                        quiz,
                                                                    score:
                                                                        score,
                                                                    answers:
                                                                        answers,
                                                                    userAnswers:
                                                                        userAnswers)),
                                                          );
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

// coverage:ignore-end
