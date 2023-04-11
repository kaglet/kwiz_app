// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class AboutQuizCard extends StatefulWidget {
  const AboutQuizCard({super.key});

  @override
  State<AboutQuizCard> createState() => _AboutQuizCardState();
}

class _AboutQuizCardState extends State<AboutQuizCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Add Title',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              minLines: 5,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'About',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: 'About',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ))),
            ),
            SizedBox(
              height: 2.0,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Category',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
