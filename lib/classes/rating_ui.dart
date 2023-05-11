import 'package:flutter/material.dart';

class RatingUI extends StatefulWidget {
  final int maximumRating = 5;
  final Function(int) onRatingSelected;
  final int? initialRating;

  RatingUI(this.onRatingSelected, {this.initialRating = 0});

  @override
  _RatingUI createState() => _RatingUI();
}

class _RatingUI extends State<RatingUI> {
  int? _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  Widget _buildRatingStar(int index) {
    if (index < _currentRating!) {
      return Icon(Icons.star, color: Colors.orange);
    } else {
      return Icon(Icons.star_border_outlined);
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });

          this.widget.onRatingSelected(_currentRating!);
        },
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: stars,
        ),
        TextButton(
          child: Text("Clear",
              style: TextStyle(color: Color.fromARGB(255, 230, 131, 44))),
          onPressed: () {
            setState(() {
              _currentRating = 0;
            });
            this.widget.onRatingSelected(_currentRating!);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
