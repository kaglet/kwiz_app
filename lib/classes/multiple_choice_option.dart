import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MultipleChoiceOption extends StatefulWidget {
  Function delete;
  Function onChanged;
  final Key? key;
  int? number;

  final _optionController = TextEditingController();

  MultipleChoiceOption(
      {required this.delete,
      required this.onChanged,
      required this.key,
      int? number})
      : super(key: key) {
    // set the optional parameter if no value is provided
    this.number = number ?? 0;
  }

  String extractOption() {
    return _optionController.text;
    // return QA object with its question and answer text assigned from the respective controllers
  }

  @override
  State<MultipleChoiceOption> createState() => _MultipleChoiceOptionState();
}

class _MultipleChoiceOptionState extends State<MultipleChoiceOption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget._optionController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
                // assign controller to this question textfield
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Option ${widget.number!}',
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: 'Option ${widget.number!}',
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

                onChanged: (value) {
                  setState(() {
                    widget.onChanged(value, widget.number! - 1);
                  });
                },
                // Add other properties to the TextField as needed
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.delete(widget.key, widget.number! - 1);
                });

                // invokes widget.delete method for this widget. It's like using this.delete and this.key except that changes for stateful widgets.
                // pass in the current widget's unique key to delete the current widget
                // widget.delete(widget.key);
              },
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
