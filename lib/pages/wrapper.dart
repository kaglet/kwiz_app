import 'package:kwiz_v2/pages/bookmark.dart';
import 'package:kwiz_v2/pages/home.dart';
import 'package:kwiz_v2/pages/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:kwiz_v2/pages/authenticate/start_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);
    print(user);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Bookmark(user: user, userID: 'TNaCcDwiABgchtIZKjURlYjimPG2',);
    }
  }
}

// //return Authenticate();
//     return const Home();
    