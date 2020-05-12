import 'package:firebase_auth/firebase_auth.dart';

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

  // sign up with email pass

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
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
