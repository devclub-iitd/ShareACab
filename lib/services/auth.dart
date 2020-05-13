import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  //sign in with email pass

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user.isEmailVerified) {
      return true;
    } else {
      await result.user.sendEmailVerification();
      return false;
    }
  }

  Future<bool> checkVerification(FirebaseUser user) async {
    if (user.isEmailVerified) {
      return true;
    } else {
      return false;
    }
  }

  // sign up with email pass

  Future<void> registerWithEmailAndPassword(String email, String password,
      String name, String mobilenum, String hostel, String sex) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    // creating a new document for user
    await DatabaseService(uid: user.uid)
        .enterUserData(name, mobilenum, hostel, sex);
    //await DatabaseService(uid: user.uid).initializeUserData();

    await result.user.sendEmailVerification();
  }

  // forgot password

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
