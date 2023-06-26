import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/AuthViews/singin_view.dart';
import 'package:shiksha/colors/colors.dart';

import '../AuthViews/ProfileBuildStepperView.dart';
import '../Components/common_component_widgets.dart';
import '../HomeView/main_tab_view.dart';
import '../Models/ModelProfileData.dart';

import '../main.dart';

class FirebaseAuthServices {
  User? get firebaseUser => firebaseAuth.currentUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // EMAIL SIGNUP
  Future<void> signUpWithEmail(
      {required String email,
      required password,
      required BuildContext context}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>SignInView()));
      });
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "Entered Password is Weak", primaryYellowColor);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Account already Exists for this Email',
            primaryYellowColor);
      } else {
        showSnackBar(context, e.message!, primaryRedColor);
      }
    }
  }

  // EMAIL LOGIN
  Future<void> signInWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        //
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool exists = prefs.containsKey('SHIKSHA_USER_PROFILE_DATA');
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseEvent databaseEvent = await databaseReference
            .child(
            "SHIKSHA_APP/USERS_DATA/${firebaseAuthServices.firebaseUser?.uid}")
            .once();

        if (exists) {
          // Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MyApp()));
        } else {
          if (databaseEvent.snapshot.value != null) {
            Map<dynamic, dynamic> temp =
            databaseEvent.snapshot.value as Map<dynamic, dynamic>;

            ModelProfileData modelProfileData = ModelProfileData.fromJson(temp);

            await prefs.setString(
                'SHIKSHA_USER_PROFILE_DATA', jsonEncode(modelProfileData));
            // Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>TabView()));
          } else {
            // Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>ProfileBuildStepperView()));
          }
        }
        //
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(context, e.message!, primaryRedColor);
    }
  }

  // SEND EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      firebaseAuth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email Verification Link is Sent to your Mail.",
          primaryGreenColor);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, primaryGreenColor);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, primaryRedColor);
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, primaryRedColor);
    }
  }
}
