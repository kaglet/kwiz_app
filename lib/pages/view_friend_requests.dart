// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/quiz_attempts.dart';
import 'package:kwiz_v2/pages/view_friends.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../services/database.dart';

class ViewFriendRequests extends StatefulWidget {
  final OurUser user;
  const ViewFriendRequests({Key? key, required this.user}) : super(key: key);

  @override
  _ViewFriendRequestsState createState() => _ViewFriendRequestsState();
}

class _ViewFriendRequestsState extends State<ViewFriendRequests> {
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
      if (friendsList![i].sender != widget.user.uid &&
          friendsList![i].status == 'pending') {
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

  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              title: const Text(
                'Friend Requests',
                style: TextStyle(
                    fontFamily: 'TitanOne',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              backgroundColor: const Color.fromARGB(255, 27, 57, 82),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
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
                        hintText: 'Search Friend Requests',
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
                                        Text(
                                          '${_displayedItems?[index].friendName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
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
                                      onPressed: () async {
                                        service.acceptFriendRequest(
                                            _displayedItems?[index].friendName,
                                            widget.user.uid,
                                            userData!.userName);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewFriends(
                                                      user: widget.user,
                                                      //chosenQuiz:
                                                      //_displayedItems?[
                                                      //    index]),
                                                    )));
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
                                        'Accept Friend Request',
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
    );
  }
}

// coverage:ignore-end