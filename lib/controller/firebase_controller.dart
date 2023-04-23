import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_me_grab/screens/home/home_screen.dart';

class FirebaseController with ChangeNotifier {
  bool isLoading = false;
  bool isLogin = false;
  Future<void> signUpFn(
      {required String signupEmail, required String signupPassword}) async {
    try {
      isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signupEmail,
        password: signupPassword,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginFn(
      {required String loginEmail,
      required String loginPassword,
      required BuildContext context}) async {
    try {
      isLogin = true;
      notifyListeners();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmail,
        password: loginPassword,
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    } catch (e) {
      log(e.toString());
    } finally {
      isLogin = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
