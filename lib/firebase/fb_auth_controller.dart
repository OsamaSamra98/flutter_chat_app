import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fb_user_controller.dart';
import 'package:flutter_chat_app/utils/helper.dart';

typedef AuthListener = void Function({required bool loggedIn});

class FbAuthController with Helper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createAccount(BuildContext context,
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // await userCredential.user?.sendEmailVerification();
      await userCredential.user?.updateDisplayName(name);
      await FbUserController().create(userCredential.user!, name);
      await _firebaseAuth.signOut();
      showSnackBar(context,
          message: "Registered successfully, verify your email!");
      return true;
    } on FirebaseAuthException catch (exception) {
      controlAuthException(context, authException: exception);
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await FbUserController().updateFcmToken();
        // if (userCredential.user!.emailVerified) {
        //   return true;
        // }
        // showSnackBar(context, message: "Email must be verified!", error: true);
        // await _firebaseAuth.signOut();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (exception) {
      controlAuthException(context, authException: exception);
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> resetPassword(BuildContext context,
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showSnackBar(context,
          message: "Reset email sent, check and change password");
      return true;
    } on FirebaseAuthException catch (exception) {
      controlAuthException(context, authException: exception);
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> signOut() async {
    return await _firebaseAuth
        .signOut()
        .then((value) => true)
        .catchError((error) => false);
  }

  String get currentUserId => _firebaseAuth.currentUser!.uid;

  String get name => _firebaseAuth.currentUser!.displayName ?? 'Name';

  bool get loggedIn => _firebaseAuth.currentUser != null;

  StreamSubscription checkUserStatus({required AuthListener authListener}) {
    return _firebaseAuth.authStateChanges().listen((User? currentUser) {
      authListener(loggedIn: currentUser != null);
    });
  }

  void controlAuthException(BuildContext context,
      {required FirebaseAuthException authException}) {
    showSnackBar(context, message: authException.message ?? "", error: true);
    switch (authException.code) {
      case "email-already-in-use":
        break;
      case "invalid-email":
        break;
      case "operation-not-allowed":
        break;
      case "weak-password":
        break;
      case "user-disabled":
        break;
      case "user-not-found":
        break;
      case "wrong-password":
        break;
    }
  }
}
