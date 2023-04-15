import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/auth.dart';
import 'package:kwiz_v2/shared/const.dart';
import 'package:kwiz_v2/shared/loading.dart';

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
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[700],
              elevation: 0.0,
              title: Text('Register with Kwiz'),
              actions: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    widget.toggleView!();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.brown[350]),
                  ),
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'First Name'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a first name' : null,
                          onChanged: (val) {
                            firstNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Last Name'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a last name' : null,
                          onChanged: (val) {
                            lastNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Username'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a username' : null,
                          onChanged: (val) {
                            userNameInput = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val!.length < 6
                              ? 'Password must be atleast 6 characters'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
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
                              dynamic result = await _auth.RegisterWithEandP(
                                  email, password, user);
                              if (this.mounted && result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please supply valid email';
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink[400]),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ))),
          );
  }
}
