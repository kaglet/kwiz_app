// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/auth.dart';
import 'package:kwiz_v2/shared/const.dart';
import 'package:kwiz_v2/shared/loading.dart';

import '../home.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //text field state
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String firstNameInput = '';
  String lastNameInput = '';
  String userNameInput = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 27, 57, 82),
              elevation: 0.0,
              title: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontFamily: 'TitanOne',
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 27, 57, 82),
                      Color.fromARGB(255, 5, 12, 31),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            hintText: 'First Name',
                            hintStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a first name' : null,
                          onChanged: (val) {
                            firstNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            hintText: 'Last Name',
                            hintStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a last name' : null,
                          onChanged: (val) {
                            lastNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a username' : null,
                          onChanged: (val) {
                            userNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Nonita',
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (val) => val!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.orange,
                                        Colors.deepOrange
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    onPressed: () async {
                                      UserData user = UserData(
                                          uID: null,
                                          firstName: firstNameInput,
                                          userName: userNameInput,
                                          lastName: lastNameInput,
                                          bookmarkedQuizzes: [],
                                          pastAttemptQuizzes: []);

                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await _auth.RegisterWithEandP(
                                                email, password, user);

                                        if (this.mounted && result == null) {
                                          setState(() {
                                            loading = false;
                                            error = 'Please supply valid email';
                                          });
                                        } 
                                        // this fixed it by commenting it out
                                        // else {
                                        //   OurUser ourUser =
                                        //       OurUser(uid: user.uID);
                                        //   Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => Home(
                                        //         user: ourUser,
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue,
                                        Color.fromARGB(255, 7, 119, 210)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.toggleView!();
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ))),
          );
  }
}

// coverage:ignore-end