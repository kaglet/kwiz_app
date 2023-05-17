// coverage:ignore-start
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//This class is what we use as our loding widget throught the entire app 
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient( //This gives the background a gradient effect that changes from a dark blue to an even darker shade
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 27, 57, 82),
              Color.fromARGB(255, 5, 12, 31),
            ],
          ),
        ),
      child: Center(
        child: SpinKitChasingDots( //Built in widget that Changes a circle progress indicator into two spinning white dots
          color: Colors.white,
          size: 50.0,
          duration: Duration(milliseconds: 700 ), //It's animation duration is 0.7 seconds
        ),
      ),
    );
  }
}
// coverage:ignore-end