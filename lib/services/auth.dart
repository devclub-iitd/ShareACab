import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in with email pass

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (result.user.emailVerified) {
      return true;
    } else {
      await result.user.sendEmailVerification();
      return false;
    }
  }

  Future<bool> checkVerification(User user) async {
    return user.emailVerified;
  }

  // sign up with email pass

  Future<void> registerWithEmailAndPassword({String email, String password, String name, String mobilenum, String hostel, String sex}) async {
    var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    var user = result.user;
    // creating a new document for user
    await DatabaseService(uid: user.uid).enterUserData(name: name, mobileNumber: mobilenum, hostel: hostel, sex: sex);
    await result.user.sendEmailVerification();
  }

  // forgot password

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // verification mail resend

  Future<void> verificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // is user verified check
  Future<bool> verificationcheck(User user) async {
    await user.reload();
    await user.getIdToken(true);
    await user.reload();
    var flag = user.emailVerified;
    return flag;
  }

  Future<User> reloadCurrentUser() async {
    var oldUser = FirebaseAuth.instance.currentUser;
    await oldUser.reload();
    var newUser = FirebaseAuth.instance.currentUser;
    return newUser;
  }

  Future<String> getCurrentUID() async {
    var user = _auth.currentUser;
    final uid = user.uid;
    return uid.toString();
  }

  // to update email
  Future<void> changeEmail(String newEmail) async {
    var user = _auth.currentUser;
    await user.updateEmail(newEmail);
  }
}
