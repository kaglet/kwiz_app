import 'package:flutter/material.dart';
import 'package:kwiz_v2/classes/multiple_choice_option.dart';
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
  String _selectedTruthValue = 'True';
  String? _selectedDropdownValue;
  final List? dropdownList = [];
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
    if (qaType == 'shortAnswer') {
      return QA(
          question: _questionController.text,
          answer: _answerController.text,
          type: 'shortAnswer');
    }
    if (qaType == 'fillInTheBlank') {
      return QA(
          question:
              _questionPreController.text + '**' + _questionPostController.text,
          answer: _answerController.text,
          type: 'fillInTheBlank');
    }
    if (qaType == 'trueOrFalse') {
      return QA(
          question: _questionController.text,
          answer: _selectedTruthValue,
          type: 'trueOrFalse');
    }
    if (qaType == 'multipleChoice') {
      String answer = _selectedDropdownValue!;
      List<String> answerOptions =
          dropdownList!.map((e) => e.toString()).toList();
      return QAMultiple(
          // answer option will come from all answerOptions controllers
          question: _questionController.text,
          answer: answer,
          type: 'multipleChoice',
          answerOptions: answerOptions);
    } 
    if (qaType == 'dropdown') {
      String answer = _selectedDropdownValue!;
      List<String> answerOptions =
          dropdownList!.map((e) => e.toString()).toList();
      return QAMultiple(
          // answer option will come from all answerOptions controllers
          question: _questionController.text,
          answer: answer,
          type: 'dropdown',
          answerOptions: answerOptions);
    }if (qaType == 'ranking') {     
      List<String> answerOptions =
          dropdownList!.map((e) => e.toString()).toList();
      String answer = answerOptions.join(",");
      print(answer);
        
      return QAMultiple(
          // answer option will come from all answerOptions controllers
          question: _questionController.text,
          answer: answer,
          type: 'ranking',
          answerOptions: answerOptions);
    }else {
      return QA(
          question: _questionController.text,
          answer: _answerController.text,
          type: 'shortAnswer');
    }
  }
  List<MultipleChoiceOption> multipleChoiceOptions = [];

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
  
  List? trueOrFalseOptions = ["True", "False"];
  final List? userInitializedAnswers = [''];
  @override
  Widget build(BuildContext context) {
    if (widget.qaType == 'shortAnswer') {
      // return short answer qa container
      SingleChildScrollView shortAnswerContainer = SingleChildScrollView(
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
      return shortAnswerContainer;
    } else if (widget.qaType == 'trueOrFalse') {
      // return short answer qa container
      SingleChildScrollView dropdownContainer = SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Center(
                child: DropdownButton(
                  isExpanded: true,
                  value: widget._selectedTruthValue,
                  onChanged: (newValue) {
                    setState(
                      () {
                        widget._selectedTruthValue = newValue as String;
                      },
                    );
                  },
                  items: trueOrFalseOptions?.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child:
                          Text(option, style: TextStyle(fontFamily: 'Nunito')),
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
                  dropdownColor: Color.fromARGB(255, 45, 64, 96),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
      return dropdownContainer;
    } else if (widget.qaType == 'fillInTheBlank') {
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
    } else if (widget.qaType == 'multipleChoice') {
      // return short answer qa container
      SingleChildScrollView multipleChoiceContainer = SingleChildScrollView(
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
                      labelText: 'Multiple Choice Question ${widget.number}',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Multiple Choice Question ${widget.number}',
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.multipleChoiceOptions!.length,                
                itemBuilder: (context, index) {
                  widget.multipleChoiceOptions.elementAt(index).number = index + 1;
                  // with each index return qaContainer at that index into listview with adjusted question number
                  return widget.multipleChoiceOptions.elementAt(index);
                },
              ),
            ),
            DropdownButton(
              isExpanded: true,
              // this value must always match the value in the list it gets items from, from the start
              value: widget._selectedDropdownValue,

              onChanged: (newValue) {
                setState(
                  () {
                    widget._selectedDropdownValue = newValue as String;
                    print(widget._selectedDropdownValue);
                  },
                );
              },
              hint:
                  Text('Select Answer', style: TextStyle(color: Colors.white)),
              items: widget.dropdownList!.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option, style: TextStyle(fontFamily: 'Nunito')),
                );
              }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                size: 20.0,
              ),
              iconEnabledColor: Colors.white, //Icon color
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white, //Font color //font size on dropdown button
              ),
              dropdownColor: Color.fromARGB(255, 45, 64, 96),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: widget.dropdownList!.length < 8
                        ? () {
                            setState(() {
                              final uniqueKey = UniqueKey();
                              widget.dropdownList!.add(
                                  'Option ${widget.dropdownList!.length + 1}');
                              widget.multipleChoiceOptions.add(MultipleChoiceOption(
                                  onChanged: (value, optionIndex) {
                                    setState(() {
                                      print(value);
                                      if (!widget.dropdownList!.contains(value)){
                                      if (widget._selectedDropdownValue ==
                                          widget.dropdownList![optionIndex]) {
                                        widget._selectedDropdownValue = value;
                                      }
                                      print(value);
                                      widget.dropdownList![optionIndex] = value;
                                      print(widget.dropdownList);
                                    }else{
                                       if (widget._selectedDropdownValue ==
                                          widget.dropdownList![optionIndex]) {
                                        widget._selectedDropdownValue = value;
                                      }
                                      widget.dropdownList![optionIndex] = "No Duplicates";

                                      //
                                      
                                     
                                    }
                                  });
                                  },
                                  // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                  // a key is passed in as a parameterwhich  is the unique key of the widget
                                  delete: (key, dropdownIndex) {
                                    setState(() {
                                      // print(widget.dropdownList![dropdownIndex]);
                                      // print(widget._selectedDropdownValue);
                                      if (!(widget
                                              .dropdownList![dropdownIndex] ==
                                          widget._selectedDropdownValue)) {
                                        widget.dropdownList!
                                            .removeAt(dropdownIndex);
                                        widget.multipleChoiceOptions.removeWhere(
                                            (multipleChoiceOption) =>
                                                multipleChoiceOption.key ==
                                                key);
                                      }
                                    });
                                  },
                                  okey: uniqueKey));
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Text(
                      'Add Option',
                      style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
      return multipleChoiceContainer;
    }else if (widget.qaType == 'dropdown') {
      // return short answer qa container
      SingleChildScrollView dropdownContainer = SingleChildScrollView(
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
                      labelText: 'Dropdown Question ${widget.number}',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Dropdown Question ${widget.number}',
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.multipleChoiceOptions!.length,                
                itemBuilder: (context, index) {
                  widget.multipleChoiceOptions.elementAt(index).number = index + 1;
                  // with each index return qaContainer at that index into listview with adjusted question number
                  return widget.multipleChoiceOptions.elementAt(index);
                },
              ),
            ),
            DropdownButton(
              isExpanded: true,
              // this value must always match the value in the list it gets items from, from the start
              value: widget._selectedDropdownValue,

              onChanged: (newValue) {
                setState(
                  () {
                    widget._selectedDropdownValue = newValue as String;
                    print(widget._selectedDropdownValue);
                  },
                );
              },
              hint:
                  Text('Select Answer', style: TextStyle(color: Colors.white)),
              items: widget.dropdownList!.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option, style: TextStyle(fontFamily: 'Nunito')),
                );
              }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                size: 20.0,
              ),
              iconEnabledColor: Colors.white, //Icon color
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white, //Font color //font size on dropdown button
              ),
              dropdownColor: Color.fromARGB(255, 45, 64, 96),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: widget.dropdownList!.length < 8
                        ? () {
                            setState(() {
                              final uniqueKey = UniqueKey();
                              widget.dropdownList!.add(
                                  'Option ${widget.dropdownList!.length + 1}');
                              widget.multipleChoiceOptions.add(MultipleChoiceOption(
                                  onChanged: (value, optionIndex) {
                                    setState(() {
                                      if (widget._selectedDropdownValue ==
                                          widget.dropdownList![optionIndex]) {
                                        widget._selectedDropdownValue = value;
                                      }
                                      print(value);
                                      widget.dropdownList![optionIndex] = value;
                                      print(widget.dropdownList);
                                    });
                                  },
                                  // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                  // a key is passed in as a parameterwhich  is the unique key of the widget
                                  delete: (key, dropdownIndex) {
                                    setState(() {
                                      // print(widget.dropdownList![dropdownIndex]);
                                      // print(widget._selectedDropdownValue);
                                      if (!(widget
                                              .dropdownList![dropdownIndex] ==
                                          widget._selectedDropdownValue)) {
                                        widget.dropdownList!
                                            .removeAt(dropdownIndex);
                                        widget.multipleChoiceOptions.removeWhere(
                                            (multipleChoiceOption) =>
                                                multipleChoiceOption.key ==
                                                key);
                                      }
                                    });
                                  },
                                  okey: uniqueKey));
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Text(
                      'Add Option',
                      style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
      return dropdownContainer;
    }
    else if (widget.qaType == 'ranking') {
      // return short answer qa container
      SingleChildScrollView rankingContainer = SingleChildScrollView(
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
                      labelText: 'Ranking Question ${widget.number}',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Ranking Question ${widget.number}',
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.multipleChoiceOptions!.length,                
                itemBuilder: (context, index) {
                  widget.multipleChoiceOptions.elementAt(index).number = index + 1;
                  // with each index return qaContainer at that index into listview with adjusted question number
                  return widget.multipleChoiceOptions.elementAt(index);
                },
              ),
            ),           
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: widget.dropdownList!.length < 8
                        ? () {
                            setState(() {
                              final uniqueKey = UniqueKey();
                              widget.dropdownList!.add(
                                  'Item ${widget.dropdownList!.length + 1}');
                              widget.multipleChoiceOptions.add(MultipleChoiceOption(
                                  onChanged: (value, optionIndex) {
                                    setState(() {                                     
                                      print(value);
                                      widget.dropdownList![optionIndex] = value;
                                      print(widget.dropdownList);
                                    });
                                  },
                                  // add new qaContainer with an anonymous delete function passed in as a paramter so container can be able to delete itself later
                                  // a key is passed in as a parameterwhich  is the unique key of the widget
                                  delete: (key, dropdownIndex) {
                                    setState(() {
                                      // print(widget.dropdownList![dropdownIndex]);
                                      // print(widget._selectedDropdownValue);
                                      
                                      if (!(widget
                                              .dropdownList![dropdownIndex] ==
                                          widget._selectedDropdownValue)) {
                                        widget.dropdownList!
                                            .removeAt(dropdownIndex);
                                        widget.multipleChoiceOptions.removeWhere(
                                            (multipleChoiceOption) =>
                                                multipleChoiceOption.key ==
                                                key);
                                                
                                      }
                                    });
                                  },
                                  okey: uniqueKey));
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
      return rankingContainer;
    }

    return SingleChildScrollView(
      child: Text('None'),
    );
  }
}
