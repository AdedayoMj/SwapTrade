import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swap/api/stream_user_api.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';

class AuthService {
  final CollectionReference _swapUsersCollection =
      FirebaseFirestore.instance.collection("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomeUser _userFromFirebaseUser(User user) {
    return user != null
        ? CustomeUser(
            uid: user.uid,
            emailVerified: user.emailVerified,
          )
        : null;
  }

//auth change user stream
  Stream<CustomeUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Signin with email and password
  Future signInWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      print(result);

      if (user.emailVerified == true) {
        _userFromFirebaseUser(user);
        return result.user != null;
      } else {
        return 'Please verify your email address';
      }
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  //signup with email and password
  Future signUpWithEmailAndPassword({
    String username,
    String email,
    String password,
  }) async {
    dynamic verifyUniqueUsername = await usernameCheck(username.toLowerCase());
    if (verifyUniqueUsername == true) {
      try {
        FirebaseApp tempApp = await Firebase.initializeApp(
            name: 'Swap', options: Firebase.app().options);
        UserCredential result = await FirebaseAuth.instanceFor(app: tempApp)
            .createUserWithEmailAndPassword(email: email, password: password);
        User user = result.user;
        await user.sendEmailVerification();

        await DatabaseService(uid: user.uid).updateUserData(
          '',
          '',
          username,
          email,
          '',
          '',
          '',
          '',
          '',
          '',
          0,
          Timestamp.now(),
        );

        return user != null;
      } catch (e) {
        print(e.message);

        return e.message;
      }
    } else {
      return 'Account with $username already exist';
    }
  }

  Future resetAccountPasswordEmail({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.message;
    }
  }

//check username
  Future<bool> usernameCheck(String username) async {
    final result =
        await _swapUsersCollection.where('username', isEqualTo: username).get();
    return result.docs.isEmpty;
  }

  Future<bool> phoneNumberCheck(String phoneNumber) async {
    final result = await _swapUsersCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    return result.docs.isEmpty;
  }

  Future checkPhoneInFirebase({
    String phoneNumber,
  }) async {
    dynamic verifyUniqueUsername = await phoneNumberCheck(phoneNumber);
    if (verifyUniqueUsername == true) {
      return null;
    } else {
      return '$phoneNumber already exist';
    }
  }

  //validate current password
  Future<bool> checkCurrentPassword(String currentPassword) async {
    return await validatePassword(currentPassword);
  }

  Future<bool> validatePassword(password) async {
    var firebaseUser = _auth.currentUser;
    // ignore: deprecated_member_use
    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void updateUserPassword(String newPassword) {
    updatePassword(newPassword);
  }

  void updatePassword(String password) async {
    var firebaseUser = _auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
