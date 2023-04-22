import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import '../services/database.dart';

class Bookmark extends StatefulWidget {
  final OurUser user;
  //final String chosenCategory;
  const Bookmark({super.key,  required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  late String categoryName;
  DatabaseService service = DatabaseService();
  List? bookmarkedQuiz = [];
  List? bookmarkedQuizList = [];
  List? _displayedItems = [];
  List<bool> isBookmarkedList = [];
  int bookmarkLength = 0;
  int bookmarkedQuizListLength = 0;
  UserData? userData;
  int catLength = 0;
  int fillLength = 0;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _displayedItems = bookmarkedQuiz;
    _startLoading();
    loadData().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> removeBookmark(int index) async {
    await service.deleteBookmarks(userID: widget.user.uid, quizID: bookmarkedQuizList![index].quizID);
  }

  // loads data from DB
  Future<void> loadData() async {
    userData = await service.getUserAndBookmarks(userID: widget.user.uid);
    bookmarkedQuizList = userData!.bookmarkedQuizzes;
    bookmarkedQuizListLength = bookmarkedQuizList!.length;

    for (int i = 0; i < bookmarkedQuizListLength; i++) {
      bookmarkedQuiz!.add(bookmarkedQuizList?[i].bookmarkQuizName.toString());
      /*marks!.add(pastAttemptsObject?[i].pastAttemptQuizMarks);
      quizID!.add(pastAttemptsObject?[i].pastAttemptQuizID.toString());
      quizName!.add(pastAttemptsObject?[i].pastAttemptQuizName.toString());
      dates!.add(pastAttemptsObject?[i].pastAttemptQuizDatesAttempted); */

    }
    bookmarkLength = bookmarkedQuiz!.length;
    _displayedItems = bookmarkedQuiz;
    fillLength = _displayedItems!.length;
    updateBookmarkList();
    print("HERE");
    print(bookmarkedQuiz);
  }

  void updateBookmarkList() {
    isBookmarkedList = List.filled(fillLength, false);

    for (int i = 0; i < fillLength; i++) {
      for (int j = 0; j < bookmarkedQuizListLength; j++) {
        if (_displayedItems!.elementAt(i).quizID ==
            bookmarkedQuizList!.elementAt(j).quizID) {
          isBookmarkedList[i] = true;
        }
      }
    }
  }

  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  final TextEditingController _searchController = TextEditingController();

//This method is used to control the search bar
  void _onSearchTextChanged(String text) {
    setState(() {
      _displayedItems = bookmarkedQuiz!
          .where((item) => item.toLowerCase().contains(text.toLowerCase()))
          .toList();
      fillLength = _displayedItems!.length;
    });
  }

  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: _isLoading
          ? null
          :AppBar(
        title: const Text(
          'My Bookmarks',
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
      body:_isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :Container(
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
                  hintText: 'Search bookmarked quizzes',
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
                  _displayedItems == null &&_isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
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
                                    _displayedItems?[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  leading: IconButton(
                                    icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        // Remove the selected bookmark from the list
                                        removeBookmark(index);
                                        // Refresh the list of displayed items
                                        setState(() {
                                          _displayedItems!.removeAt(index);
                                          bookmarkedQuizList!.removeAt(index);
                                          fillLength = _displayedItems!.length;
                                        });
                                      },
                                      color: Colors.white,
                                  ),
                                  
                                  textColor: Colors.white,
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Author: (TBA)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Category: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Date Created: '
                                          /*filteredQuizzes!
                                              .elementAt(index)
                                              .quizDateCreated*/
                                          ,
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
                                      onPressed: () {
                                         Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StartQuiz(
                                                                          user: widget.user ,
                                                                          chosenQuiz: bookmarkedQuizList?[index].quizID),
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
                                        'Start Quiz',
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
