import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/ProfileBuildStepperView.dart';
import 'package:shiksha/AuthViews/SingInView.dart';
import 'package:shiksha/Components/LoadingIndicator.dart';
import 'package:shiksha/Components/ShowSnackBar.dart';
import 'package:shiksha/FirebaseServices/FirebaseService.dart';
import 'package:shiksha/colors/colors.dart';
import 'package:shiksha/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {

  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> signUpFormKey = GlobalKey();

  bool _obscureText = true;

  String? passwordValidate(value) {
    if (value!.isEmpty) {
      return "Password Required!";
    } else if (value.toString().length < 8 || value.toString().length > 14) {
      return "Password length should be between 8 to 14 chars.";
    } else {
      return null;
    }
  }



  void signUpUser() async {
    firebaseAuthServices.signUpWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      context: context,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryWhiteColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderImage(),
                Center(
                  child: CustomText(
                      text: "SIGN UP", textSize: 28, color: PrimaryDarkColor),
                ),
                const SizedBox(
                  height: 0,
                ),
                Center(
                  child: CustomText(
                      text: "Create an Account, To Get Started",
                      textSize: 18,
                      color: PrimaryDarkColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CustomText(
                      text: "Enter your Mail associated with College Domain",
                      textSize: 12,
                      color: PrimaryDarkColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: signUpFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter Email...",
                              prefixIcon: const Icon(MdiIcons.emailOutline),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: PrimaryDarkColor.withOpacity(0.1),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "E-Mail Required!";
                              }

                              var rx = RegExp("\b*@klescet\.ac\.in\$",
                                  caseSensitive: false);
                              return rx.hasMatch(value)
                                  ? null
                                  : 'Invalid E-Mail Domain';
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(MdiIcons.lock),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: PrimaryDarkColor.withOpacity(0.1),
                              hintText: 'Enter your Password',
                              // Here is key idea
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? MdiIcons.toggleSwitch
                                      : MdiIcons.toggleSwitchOffOutline,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            controller: passwordController,
                            obscureText: _obscureText,
                            validator: passwordValidate,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(MdiIcons.lock),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: PrimaryDarkColor.withOpacity(0.1),
                              hintText: 'Confirm your Password',
                              // Here is key idea
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? MdiIcons.toggleSwitch
                                      : MdiIcons.toggleSwitchOffOutline,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            controller: confirmPasswordController,
                            obscureText: _obscureText,
                            validator: passwordValidate,
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AuthButtons(
                        buttonSize: 60,
                        buttonContext: context,
                        buttonFunction: () {
                          if (signUpFormKey.currentState!.validate()) {
                            showLoaderDialog(context, "Signing Up..");
                            firebaseAuthServices.signUpWithEmail(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context);
                          }
                        },
                        buttonText: 'CREATE ACCOUNT',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Divider(
                            color: PrimaryDarkColor,
                          )),
                          CustomText(
                              text: "Already have an Account ?",
                              textSize: 14,
                              color: PrimaryDarkColor),
                          Expanded(
                              child: Divider(
                            color: PrimaryDarkColor,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButtons(
                        buttonSize: 60,
                        buttonContext: context,
                        buttonActivity: const SignInView(),
                        buttonFunction: () {},
                        buttonText: 'SIGN IN',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TermsAndConditionsText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
