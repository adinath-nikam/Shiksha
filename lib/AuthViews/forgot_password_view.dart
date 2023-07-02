import 'package:flutter/material.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../colors/colors.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key? key}) : super(key: key);
  final TextEditingController forgotPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: appBarCommon(context, "RESET PASSWORD")),
      backgroundColor: primaryWhiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_reset_rounded,
                  color: primaryDarkColor,
                  size: 80,
                ),
                const SizedBox(
                  height: 30,
                ),
                customTextBold(
                    text: "Reset your Password",
                    textSize: 24,
                    color: primaryDarkColor),
                customTextBold(
                    text: "Password Reset Link will be Sent to this Mail ID.",
                    textSize: 12,
                    color: primaryDarkColor.withAlpha(100)),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: forgotPasswordController,
                    decoration: InputDecoration(
                      hintText: "Enter Registered Email...",
                      prefixIcon: const Icon(Icons.mail_outline_outlined),
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
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                AuthButtons(
                  buttonSize: 60,
                  buttonContext: context,
                  buttonFunction: () {
                    firebaseAuthServices.sendPasswordResetLink(context, email: forgotPasswordController.text.trim().toString());
                  },
                  buttonText: 'RESET PASSWORD',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}