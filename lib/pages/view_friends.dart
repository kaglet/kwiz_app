// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/quiz_attempts.dart';
import 'package:kwiz_v2/pages/view_friend_requests.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../services/database.dart';

class ViewFriends extends StatefulWidget {
  final OurUser user;
  const ViewFriends({Key? key, required this.user}) : super(key: key);

  @override
  _ViewFriendsState createState() => _ViewFriendsState();
}

class _ViewFriendsState extends State<ViewFriends> {
  late String? myUsername;
  late String _username;
  DatabaseService service = DatabaseService();
  List<dynamic>? friendsList = [];
  int friendsListLength = 0;
  List<dynamic>? friends = [];
  int friendsLength = 0;
  List<dynamic>? _displayedItems = [];
  bool _isLoading = true;
  int fillLength = 0;
  UserData? userData;
  String? name = '';
  final TextEditingController _searchController = TextEditingController();
  String error = "";

  @override
  void initState() {
    super.initState();
    _displayedItems = friends;
    _startLoading();
    loaddata().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loaddata() async {
    DatabaseService service = DatabaseService();
    myUsername = await service.getMyUsername(widget.user.uid);
    userData = await service.getUserAndFriends(userID: widget.user.uid);
    friendsList = userData!.friends;
    friendsListLength = friendsList!.length;
    //Extracting the List of distinct quiz names for each past attempt
    for (int i = 0; i < friendsListLength; i++) {
      if (friendsList![i].status != 'pending') {
        friends!.add(friendsList?[i]);
      }
    }
    friendsLength = friends!.length;
    _displayedItems = friends;
    fillLength = _displayedItems!.length;
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _displayedItems = friends!
          .where((item) =>
              item.friendName.toLowerCase().contains(text.toLowerCase()))
          .toList();
      fillLength = _displayedItems!.length;
    });
  }

  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 1300));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addFriendDialog() async {
    bool userExists = false; // Local variable to track user existence

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor:
                  Colors.transparent, // Set the background color to transparent
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 27, 57, 82),
                      Color.fromARGB(255, 11, 26, 68),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Enter the username',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) {
                          _username = value;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type username here...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 2.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: error,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              error = '';
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50.0),
                        TextButton(
                          onPressed: () async {
                            userExists = await service.userExists(_username);

                            if (userExists && _username != myUsername) {
                              bool alreadyFriends = false;
                              alreadyFriends = await service.alreadyFriends(
                                  _username, widget.user.uid);

                              if (alreadyFriends) {
                                setState(() {
                                  error =
                                      'Friend Request Already Sent/Already friends';
                                });
                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: false,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       backgroundColor: Colors
                                //           .transparent, // Set the background color to transparent
                                //       contentPadding: EdgeInsets.zero,
                                //       content: Container(
                                //         padding: EdgeInsets.symmetric(
                                //             vertical: 10.0, horizontal: 10.0),
                                //         decoration: BoxDecoration(
                                //           gradient: const LinearGradient(
                                //             begin: Alignment.topLeft,
                                //             end: Alignment.bottomRight,
                                //             colors: [
                                //               Color.fromARGB(255, 27, 57, 82),
                                //               Color.fromARGB(255, 11, 26, 68),
                                //             ],
                                //           ),
                                //           borderRadius:
                                //               BorderRadius.circular(20.0),
                                //         ),
                                //         child: Column(
                                //           mainAxisSize: MainAxisSize.min,
                                //           children: [
                                //             const Text(
                                //               'Friend Request Already Sent/Already Friends',
                                //               style: TextStyle(
                                //                 color: Colors.white,
                                //                 fontSize: 20.0,
                                //                 letterSpacing: 1.0,
                                //                 fontFamily: 'Nunito',
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       actions: <Widget>[
                                //         TextButton(
                                //           child: const Text('OK'),
                                //           onPressed: () {
                                //             Navigator.of(context).pop();
                                //             Navigator.of(context).pop();
                                //           },
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // );
                              } else {
                                await service.addFriend(_username,
                                    widget.user.uid, userData!.userName);
                                setState(() {
                                  error = 'Your friend request has been sent.';
                                });
                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: false,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       backgroundColor: Colors
                                //           .transparent, // Set the background color to transparent
                                //       contentPadding: EdgeInsets.zero,
                                //       content: Container(
                                //         padding: EdgeInsets.symmetric(
                                //             vertical: 10.0, horizontal: 10.0),
                                //         decoration: BoxDecoration(
                                //           gradient: const LinearGradient(
                                //             begin: Alignment.topLeft,
                                //             end: Alignment.bottomRight,
                                //             colors: [
                                //               Color.fromARGB(255, 27, 57, 82),
                                //               Color.fromARGB(255, 11, 26, 68),
                                //             ],
                                //           ),
                                //           borderRadius:
                                //               BorderRadius.circular(20.0),
                                //         ),
                                //         child: Column(
                                //           mainAxisSize: MainAxisSize.min,
                                //           children: [
                                //             const Text(
                                //               'Your friend request has been sent.',
                                //               style: TextStyle(
                                //                 color: Colors.white,
                                //                 fontSize: 20.0,
                                //                 letterSpacing: 1.0,
                                //                 fontFamily: 'Nunito',
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       actions: <Widget>[
                                //         TextButton(
                                //           child: const Text('OK'),
                                //           onPressed: () {
                                //             Navigator.of(context).pop();
                                //             Navigator.of(context).pop();
                                //           },
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // );
                              }
                            } else if (_username == myUsername) {
                              setState(() {
                                error = 'That is your username.';
                              });
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       backgroundColor: Colors
                              //           .transparent, // Set the background color to transparent
                              //       contentPadding: EdgeInsets.zero,
                              //       content: Container(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 10.0, horizontal: 10.0),
                              //         decoration: BoxDecoration(
                              //           gradient: const LinearGradient(
                              //             begin: Alignment.topLeft,
                              //             end: Alignment.bottomRight,
                              //             colors: [
                              //               Color.fromARGB(255, 27, 57, 82),
                              //               Color.fromARGB(255, 11, 26, 68),
                              //             ],
                              //           ),
                              //           borderRadius:
                              //               BorderRadius.circular(20.0),
                              //         ),
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             const Text(
                              //               'That is your username',
                              //               style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 20.0,
                              //                 letterSpacing: 1.0,
                              //                 fontFamily: 'Nunito',
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       actions: <Widget>[
                              //         TextButton(
                              //           child: const Text('OK'),
                              //           onPressed: () {
                              //             Navigator.of(context).pop();
                              //           },
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );
                            } else {
                              setState(() {
                                error = 'The entered username does not exist.';
                              });
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       backgroundColor: Colors
                              //           .transparent, // Set the background color to transparent
                              //       contentPadding: EdgeInsets.zero,
                              //       content: Container(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 10.0, horizontal: 10.0),
                              //         decoration: BoxDecoration(
                              //           gradient: const LinearGradient(
                              //             begin: Alignment.topLeft,
                              //             end: Alignment.bottomRight,
                              //             colors: [
                              //               Color.fromARGB(255, 27, 57, 82),
                              //               Color.fromARGB(255, 11, 26, 68),
                              //             ],
                              //           ),
                              //           borderRadius:
                              //               BorderRadius.circular(20.0),
                              //         ),
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             const Text(
                              //               'The entered username does not exist.',
                              //               style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 20.0,
                              //                 letterSpacing: 1.0,
                              //                 fontFamily: 'Nunito',
                              //               ),
                              //             ),
                              //             TextButton(
                              //               child: const Text('OK'),
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       actions: <Widget>[],
                              //     );
                              //   },
                              // );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 222, 127, 43),
                                  Color.fromARGB(255, 246, 120, 82),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ),
                        // TextButton(
                        //   child: const Text('Add'),
                        //   onPressed: () async {
                        //     userExists = await service.userExists(_username);

                        //     if (userExists && _username != myUsername) {
                        //       bool alreadyFriends = false;
                        //       alreadyFriends = await service.alreadyFriends(
                        //           _username, widget.user.uid);

                        //       if (alreadyFriends) {
                        //         showDialog(
                        //           context: context,
                        //           barrierDismissible: false,
                        //           builder: (BuildContext context) {
                        //             return AlertDialog(
                        //               content: const Text(
                        //                 'Friend Request Already Sent/Already Friends',
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 20.0,
                        //                   letterSpacing: 1.0,
                        //                   fontFamily: 'Nunito',
                        //                 ),
                        //               ),
                        //               actions: <Widget>[
                        //                 TextButton(
                        //                   child: const Text('OK'),
                        //                   onPressed: () {
                        //                     Navigator.of(context).pop();
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       } else {
                        //         await service.addFriend(_username,
                        //             widget.user.uid, userData!.userName);
                        //         showDialog(
                        //           context: context,
                        //           barrierDismissible: false,
                        //           builder: (BuildContext context) {
                        //             return AlertDialog(
                        //               content: const Text(
                        //                 'Your friend request has been sent.',
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 20.0,
                        //                   letterSpacing: 1.0,
                        //                   fontFamily: 'Nunito',
                        //                 ),
                        //               ),
                        //               actions: <Widget>[
                        //                 TextButton(
                        //                   child: const Text('OK'),
                        //                   onPressed: () {
                        //                     Navigator.of(context).pop();
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       }
                        //     } else if (_username == myUsername) {
                        //       showDialog(
                        //         context: context,
                        //         barrierDismissible: false,
                        //         builder: (BuildContext context) {
                        //           return AlertDialog(
                        //             content: const Text(
                        //               'That is your username',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20.0,
                        //                 letterSpacing: 1.0,
                        //                 fontFamily: 'Nunito',
                        //               ),
                        //             ),
                        //             actions: <Widget>[
                        //               TextButton(
                        //                 child: const Text('OK'),
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       );
                        //     } else {
                        //       showDialog(
                        //         context: context,
                        //         barrierDismissible: false,
                        //         builder: (BuildContext context) {
                        //           return AlertDialog(
                        //             content: const Text(
                        //               'The entered username does not exist.',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20.0,
                        //                 letterSpacing: 1.0,
                        //                 fontFamily: 'Nunito',
                        //               ),
                        //             ),
                        //             actions: <Widget>[
                        //               TextButton(
                        //                 child: const Text('OK'),
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       );
                        //     }
                        //   },
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'Friends',
                style: TextStyle(
                    fontFamily: 'TitanOne',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              backgroundColor: const Color.fromARGB(255, 27, 57, 82),
              leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
      body: _isLoading
          ? Loading()
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 27, 57, 82),
                    Color.fromARGB(255, 5, 12, 31),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 45, 64,
                            96), // set the background color to a darker grey
                        hintText: 'Search friends',
                        hintStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily:
                              'Nunito', // set the hint text color to a light grey
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          color: const Color.fromRGBO(192, 192, 192,
                              1), // set the search icon color to a light grey
                          onPressed: () {},
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(81, 95, 87,
                                  1)), // set the border color to a darker grey
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .white), // set the focused border color to white
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onChanged: _onSearchTextChanged,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(),
                        ),
                        ListView.builder(
                          itemCount: fillLength,
                          itemBuilder: (context, index) {
                            final List<Color> blueAndOrangeShades = [
                              Colors.orange.shade400,
                              Colors.orange.shade500,
                              Colors.orange.shade600,
                              Colors.orange.shade700,
                            ];

                            final Color color1 = blueAndOrangeShades[
                                index % blueAndOrangeShades.length];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: color1,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                color: const Color.fromARGB(240, 45, 64, 96),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                  title: Text(
                                    _displayedItems?[index].friendName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${_displayedItems?[index].status} |',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          color1,
                                          const Color.fromARGB(
                                              255, 59, 98, 172),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QuizAttempts(
                                                      user: widget.user,
                                                      chosenQuiz:
                                                          _displayedItems?[
                                                              index]),
                                            ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .transparent, // remove button background color
                                        elevation: 0, // remove button shadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Remove Friend',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: Container(
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 233, 136, 25),
                      Color.fromARGB(255, 233, 136, 25)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewFriendRequests(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Friend Requests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0), // Add spacing between the buttons
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 233, 136, 25),
                      Color.fromARGB(255, 233, 136, 25)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    _addFriendDialog();
                  },
                  child: const Text(
                    'Add Friend',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// coverage:ignore-end
