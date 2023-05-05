import 'package:flutter/material.dart';
import 'qa_obj.dart';

class QAContainer extends StatefulWidget {
  Function delete;
  String qaType;
  @override
  final Key? key;

  // create a question and answer controller to receive this widget's question and answer text field inputs
  final _questionController = TextEditingController();
  final _questionPreController = TextEditingController();
  final _questionPostController = TextEditingController();
  final _answerController = TextEditingController();
  int? number;

  QAContainer(
      {required this.delete,
      required this.qaType,
      required this.key,
      int? number})
      : super(key: key) {
    // set the optional parameter if no value is provided
    this.number = number ?? 0;
  }


  // for this  qaContainer which encapsulates data extract the question and answer data
  QA extractQA() {
    // return QA object with its question and answer text assigned from the respective controllers
    if (qaType== 'shortAnswer'){
    return QA(
        question: _questionController.text, answer: _answerController.text, type:'shortAnswer');
    }
    if (qaType== 'fillInTheBlank'){
    return QA(
        question: _questionPreController.text + "**"+ _questionPostController.text, answer: _answerController.text, type:'fillInTheBlank');
    }
     if (qaType== 'multipleChoice'){
    return QAMultiple(
        // answer option will come from all answerOptions controllers
        question: _questionController.text, answer: _answerController.text, type:'multipleChoice', answerOptions: []);
    }
    else{
      return QA(
        question: _questionController.text, answer: _answerController.text,type:'shortAnswer');
    }
    }

    @override
    State<QAContainer> createState() => _QAContainerState();
  }





class _QAContainerState extends State<QAContainer> {
  @override
  // void dispose() {
  //   // Dispose the controllers when the widget is disposed
  //   widget._questionController.dispose();
  //   widget._answerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.qaType == 'shortAnswer') {
      // return short answer qa container
      SingleChildScrollView scrollview = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // invokes widget.delete method for this widget. It's like using this.delete and this.key except that changes for stateful widgets.
                    // pass in the current widget's unique key to delete the current widget
                    widget.delete(widget.key);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 45, 64, 96),
                    Color.fromARGB(255, 45, 64, 96),
                  ],
                ),
              ),
              child: SizedBox(
                  height: 100,
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                    // assign controller to this question textfield
                    controller: widget._questionController,
                    minLines: 3,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Question ${widget.number}',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Question ${widget.number}',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 45, 64, 96),
                    Color.fromARGB(255, 45, 64, 96),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                      // assign controller to this answer textfield
                      controller: widget._answerController,
                      minLines: 1,
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Answer',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'Answer',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
      return scrollview;
    }

    if (widget.qaType == 'fillInTheBlank') {
      // return short answer qa container
      SingleChildScrollView scrollview = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // invokes widget.delete method for this widget. It's like using this.delete and this.key except that changes for stateful widgets.
                    // pass in the current widget's unique key to delete the current widget
                    widget.delete(widget.key);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 45, 64, 96),
                    Color.fromARGB(255, 45, 64, 96),
                  ],
                ),
              ),
              child: SizedBox(
                  height: 100,
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                    // assign controller to this question textfield
                    controller: widget._questionPreController,
                    minLines: 3,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Question ${widget.number} - pre Blank',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Question ${widget.number} - pre Blank',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 45, 64, 96),
                    Color.fromARGB(255, 45, 64, 96),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                      // assign controller to this answer textfield
                      controller: widget._answerController,
                      minLines: 1,
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Blank Space',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'Blank Space',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 45, 64, 96),
                    Color.fromARGB(255, 45, 64, 96),
                  ],
                ),
              ),
              child: SizedBox(
                  height: 100,
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                    // assign controller to this question textfield
                    controller: widget._questionPostController,
                    minLines: 3,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Question ${widget.number} - post Blank',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Question ${widget.number} - post Blank',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      );
      return scrollview;
    }
    return SingleChildScrollView(
      child: Text('None'),
    );
  }
}
