import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/AuthViews/forgot_password_view.dart';
import 'package:shiksha/AuthViews/signup_view.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/FirebaseServices/firebase_service.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../Components/common_component_widgets.dart';
import '../HomeView/main_tab_view.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryWhiteColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                headerImage(),
                Center(
                  child: customTextBold(
                      text: "LOGIN", textSize: 28, color: primaryDarkColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: customTextBold(
                      text: "Verify your Email Get Started",
                      textSize: 18,
                      color: primaryDarkColor),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: customTextBold(
                      text: "Enter your Mail associated with College Domain",
                      textSize: 12,
                      color: primaryDarkColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: signInFormKey,
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
                              fillColor: primaryDarkColor.withOpacity(0.1),
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
                            height: 20,
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
                              fillColor: primaryDarkColor.withOpacity(0.1),
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
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            controller: passwordController,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password Required!";
                              } else if (value.toString().length < 8 ||
                                  value.toString().length > 14) {
                                return "Password length should be between 8 to 14 chars.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => ForgotPasswordView()));
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: customTextBold(
                        text: "Forgot Password ?",
                        textSize: 12,
                        color: primaryDarkColor),
                  ),
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
                          if (signInFormKey.currentState!.validate()) {
                            showLoaderDialog(context, "Signing In..");

                            firebaseAuthServices.signInWithEmail(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context);


                          }
                        },
                        buttonText: 'SIGN IN',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Divider(
                            color: primaryDarkColor,
                          )),
                          customTextBold(
                              text: "Don't have an Account ?",
                              textSize: 14,
                              color: primaryDarkColor),
                          Expanded(
                              child: Divider(
                            color: primaryDarkColor,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButtons(
                        buttonSize: 60,
                        buttonContext: context,
                        buttonActivity: const SignupView(),
                        buttonFunction: () {},
                        buttonText: 'SIGN UP',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      termsAndConditionsText(),
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
