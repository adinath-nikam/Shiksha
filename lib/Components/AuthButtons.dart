import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../colors/colors.dart';
import 'CommonComponentWidgets.dart';
import 'ShowSnackBar.dart';

class AuthButtons extends StatelessWidget {
  final String buttonText;
  final Function buttonFunction;
  final BuildContext buttonContext;
  final double buttonSize;
  final Widget? buttonActivity;

  const AuthButtons(
      {Key? key,
      required this.buttonContext,
      required this.buttonSize,
      required this.buttonText,
      required this.buttonFunction,
      this.buttonActivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomButton(
          text: buttonText,
          buttonSize: buttonSize,
          context: buttonContext,
          function: buttonFunction,
      activity: buttonActivity),
    );
  }
}

//Custom Button
Widget CustomButton(
    {required String text,
    required double buttonSize,
    required BuildContext context,
    required Function function,
    Widget? activity}) {
  return SizedBox(
    height: buttonSize,
    width: double.infinity,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryDarkColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            showSnackBar(context, "You're not Connected to Internet.", PrimaryRedColor);
          } else {
            if(activity != null){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> activity));
            }else {
              function();
            }
          }
        },
        child: CustomText(text: text, textSize: 14, color: PrimaryWhiteColor)),
  );
}

//Custom Delete Button
Widget CustomDeleteButton(
    {required String text,
      required double buttonHeight,
      required BuildContext context,
      required Function function,
      Widget? activity}) {
  return SizedBox(
    height: buttonHeight,
    width: double.infinity,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryRedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            showSnackBar(context, "You're not Connected to Internet.", PrimaryRedColor);
          } else {
            if(activity != null){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> activity));
            }else {
              function();
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: text, textSize: 14, color: PrimaryWhiteColor),
            SizedBox(width: 20,),
            Icon(
              MdiIcons.delete,
              color: PrimaryWhiteColor,
            )
          ],
        )),
  );
}
