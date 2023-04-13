import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/models/user.dart';
import 'package:test/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creat ourUser based on User
  ourUser? _userFromUser(User? user) {
    return user != null ? ourUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<ourUser?> get user {
    return _auth.authStateChanges().map(_userFromUser);
    //.map((User? user) => _userFromUser(user)); (the same as above)
  }

  //sign in anom
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and pass
  Future SignInWithEandP(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future RegisterWithEandP(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid)
          .updateUserData('0', 'new memeber', 100);
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
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
