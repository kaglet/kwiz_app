// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/authenticate/register.dart';
import 'package:kwiz_v2/services/auth.dart';
import 'package:kwiz_v2/shared/const.dart';
import 'package:kwiz_v2/shared/loading.dart';
import 'package:kwiz_v2/models/user.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 27, 57, 82),
              elevation: 0.0,
              title: Center(
                child: Text(
                  'KWIZ',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'TitanOne',
                  ),
                ),
              ),
              /*actions: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    widget.toggleView!();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.brown[350]),
                  ),
                )
              ],*/
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
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Form(
                        key: _formkey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Image.asset('assets/images/KWIZLogo2.png',
                                  height: 200, width: 200, scale: 0.5),
                              SizedBox(
                                height: 30,
                              ),
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
                                    val!.isEmpty ? 'Enter your email' : null,
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
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter your password' : null,
                                obscureText: true,
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                              SizedBox(height: 20.0),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            setState(() => loading = true);
                                            dynamic result =
                                                await _auth.SignInWithEandP(
                                                    email, password);
                                            if (result == null) {
                                              setState(() {
                                                loading = false;
                                                error =
                                                    'could not sign in with those credentials';
                                              });
                                            } /*else{
                                          OurUser ourUser = OurUser(uid: user.uID);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Home(
                                                user: ourUser,
                                              ),
                                            ),
                                          );
                                        }*/
                                          }
                                        },
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          widget.toggleView!();
                                        },
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                            color: Colors.white,
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
                              SizedBox(height: 20.0),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              )
                            ],
                          ),
                        )),
                  ],
                )),
          );
  }
}

// coverage:ignore-start