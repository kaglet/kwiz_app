import 'package:firebase_auth/firebase_auth.dart';
import '../services/database.dart';
import '../models/user.dart';
import '../services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creat ourUser based on User
  OurUser? _userFromFirebaseUser(User? user) {
    return user != null ? OurUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<OurUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User? user) => _userFromUser(user)); (the same as above)
  }

  //sign in anom
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//   //sign in with email and pass
  Future SignInWithEandP(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future RegisterWithEandP(
      String email, String password, UserData userData) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      OurUser? ourUser = _userFromFirebaseUser(user);
      await DatabaseService().addUser(userData, ourUser!);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
