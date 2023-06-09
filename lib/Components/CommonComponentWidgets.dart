import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../colors/colors.dart';
import 'AuthButtons.dart';
import 'ShowSnackBar.dart';

// Custom Text Widget
Widget CustomText(
    {required String text, required double textSize, required Color color, bool? softwrap}) {
  return Text(
    text,
    textAlign: TextAlign.left,
    overflow: TextOverflow.fade,
    softWrap: softwrap,
    style: TextStyle(
      fontSize: textSize,
      fontFamily: "ProductSans-Bold",
      color: color,
    ),
  );
}

Widget CustomTextRegular(
    {required String text, required double textSize, required Color color, bool? softwrap}) {
  return Text(
    text,
    textAlign: TextAlign.left,
    overflow: TextOverflow.fade,
    softWrap: softwrap,
    style: TextStyle(
      fontSize: textSize,
      fontFamily: "ProductSans-Regular",
      color: color,
    ),
  );
}

Widget CommonAlertDialog(BuildContext context, String ButtonText, Icon icon, Function function, int functionCount) {
  return AlertDialog(
    title: CustomText(text: ButtonText, textSize: 18, color: PrimaryDarkColor),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Column(
              children: [
                icon
              ],
            )),
      ],
    ),
    actions: <Widget>[
      CustomButton(
          text: 'OK',
          buttonSize: 50,
          context: context,
          function: () {

            for(int i=0; i<functionCount; i++){
              function();
            }

            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          })
    ],
  );
}

// Terms and Conditions
Widget TermsAndConditionsText() {
  void launchTermsConditionsTab() async {
    try {
      launch('https://github.com');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  return GestureDetector(
    onTap: () => launchTermsConditionsTab(),
    child: CustomText(
        text: "By Singing Up You Agree to our Terms and Conditions",
        textSize: 12,
        color: PrimaryDarkColor),
  );
}

//Header Image
Widget HeaderImage() {
  return Container(
    child: const Align(
      alignment: Alignment.center,
      child: Image(
        image: AssetImage("assets/images/logo_main.png"),
        height: 150,
        width: 150,
      ),
    ),
  );
}

// Circular Progress Indicator
showLoaderDialog(BuildContext context, String progressIndicatorText) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: CustomText(text: progressIndicatorText, textSize: 14, color: PrimaryDarkColor)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
