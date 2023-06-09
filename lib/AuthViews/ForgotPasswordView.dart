import 'package:flutter/material.dart';
import 'package:shiksha/AuthViews/SingInView.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';

import '../colors/colors.dart';
import 'ProfileBuildStepperView.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  final TextEditingController forgotPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: PrimaryWhiteColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: NetworkImage(
                "https://inspektorat.paserkab.go.id/po-admin/assets/img/img18.png",
              ),
              height: 200,
              width: 200,
            ),
            CustomText(
                text: "Reset your Password",
                textSize: 24,
                color: PrimaryDarkColor),
            CustomText(
                text: "Password Reset Link will be Sent to this Mail ID.",
                textSize: 12,
                color: PrimaryDarkColor.withAlpha(100)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: forgotPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Registered Email...",
                  prefixIcon: const Icon(Icons.password),
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
              ),
            ),
            SizedBox(
              height: 50,
            ),
            AuthButtons(
              buttonSize: 60,
              buttonContext: context,
              buttonFunction: () {
                print("Hello");
              },
              buttonText: 'RESET PASSWORD',
            ),
          ],
        ),
      ),
    ));
  }
}
