// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/auth.dart';
import 'package:kwiz_v2/shared/const.dart';
import 'package:kwiz_v2/shared/loading.dart';

import '../../services/database.dart';
import '../home.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //This service is an object that allows us to use our database functions and methods
  DatabaseService service = DatabaseService();
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String firstNameInput = '';
  String lastNameInput = '';
  String userNameInput = '';
  List<UserData>? users;

  //Initialises the page
  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {});
    });
  }

  //This function loads all the users that are stored in the database
  Future<void> loadData() async {
    users = await service.getAllUsers(); //user.uid
  }

  //This function is a linear search that checks whether or not a user already exists in the database by checking usernames
  bool searchUserName(List<UserData> arr, String key) {
    int n = arr.length;
    bool found = false;

    for (int i = 0; i < n; i++) {
      if (arr.elementAt(i).userName == key) {
        found = true;
      }
    }
    return found;
  }

  @override
  Widget build(BuildContext context) {
    return loading //This boolean value is what calls the loading class if it is set to true
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
                //This container houses the body of the page
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // This is what gives the background a gradient effect
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
                    key:
                        _formkey, //This formkey ensures that the user enters valid data
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
                          validator: (val) => val!.isEmpty
                              ? 'Enter a first name'
                              : null, //Checks if a first name was entered
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
                          validator: (val) => val!.isEmpty
                              ? 'Enter a last name'
                              : null, //Checks if a last name was entered
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
                              //Checks if a username was entered. It aslo checks if that username is unique
                              val!.isEmpty
                                  ? 'Enter a username'
                                  : searchUserName(users!, val)
                                      ? 'Username already exists'
                                      : null,
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
                              //Checks if an email address was entered
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
                              //Checks if a password was entered. The password must contain 6 characters
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
                                      //Userdata object that is pushed to the database
                                      UserData user = UserData(
                                          uID: null,
                                          firstName: firstNameInput,
                                          userName: userNameInput,
                                          lastName: lastNameInput,
                                          totalScore: '0',
                                          totalQuizzes: 0,
                                          bookmarkedQuizzes: [],
                                          pastAttemptQuizzes: [],
                                          ratings: [],
                                          friends: []);

                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          loading =
                                              true; //Calls the loading class
                                        });
                                        //Checks if the user was sucesfully added to the database
                                        dynamic result =
                                            await _auth.RegisterWithEandP(
                                                email, password, user);
                                        //Checks if user entered a unique email
                                        if (result == "InUse") {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'This email is already in use';
                                          });
                                        }
                                        //Check if the email is valid
                                        if (result == null) {
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
                                      'Return to login',
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
                                SizedBox(height: 20.0),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
          );
  }
}

// coverage:ignore-end