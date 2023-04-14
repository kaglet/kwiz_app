import 'package:flutter/material.dart';
import 'package:kwiz_v2/pages/authenticate/register.dart';
import 'package:kwiz_v2/services/auth.dart';
import 'package:kwiz_v2/shared/const.dart';
import 'package:kwiz_v2/shared/loading.dart';

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
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[700],
              elevation: 0.0,
              title: Text('Sign in to Kwiz'),
              actions: <Widget>[
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
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your email' : null,
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your password' : null,
                          obscureText: true,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.SignInWithEandP(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'could not sign in with those credentials';
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
