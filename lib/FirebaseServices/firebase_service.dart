import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/AuthViews/singin_view.dart';
import 'package:shiksha/colors/colors.dart';
import '../Components/common_component_widgets.dart';
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

        Navigator.of(context)
            .push(animatedRoute(const SignInView()));


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
        Navigator.of(context)
            .push(animatedRoute(const MyApp()));

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


  // SEND PASSWORD RESET LINK
  Future<void> sendPasswordResetLink(BuildContext context, {required String email}) async {
    try {
      showLoaderDialog(context, "Please Wait..");
      firebaseAuth.sendPasswordResetEmail(email: email).whenComplete(() {

        Navigator.of(context).pop();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              WillPopScope(
                onWillPop: () async => false,
                child: commonAlertDialog(
                    context,
                    "Reset Link is Sent.",
                    Icon(
                      Icons.mark_email_read_rounded,
                      color: primaryDarkColor,
                      size: 50,
                    ), () {
                  Navigator.of(context).pop();
                }, 1),
              ),
        );

      });
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
