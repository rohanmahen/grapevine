import 'package:firebase_auth/firebase_auth.dart';
import 'package:grapevine_app/models/user.dart';
import 'package:grapevine_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<MyUser> get authStream {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Create User object based on Firebase User
  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(userID: user.uid) : null;
  }

  // Sign in Anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String fullname, String username, DateTime userBirthday, String userSex) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      await DatabaseService(userID: user.uid)
          .updateUserData(username, email, fullname, userBirthday, userSex);
      await DatabaseService(userID: user.uid).createUsernameDocument(username);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Reset password
  Future resetPassword(String newPassword, String oldPassword) async {
    try {
      // TO DO
    } catch (e) {}
  }

  // Log out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
