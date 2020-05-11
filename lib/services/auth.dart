import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebaseuser

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }

  //sign in anonymously
  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user.isEmailVerified) {
        return result.user.uid;
      } else {
        print('Not verified');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign up with email pass

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        await result.user.sendEmailVerification();
        return result.user.uid;
      } catch (e) {
        print('couldnt send mail');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // forgot password

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
