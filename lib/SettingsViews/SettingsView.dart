import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/SingInView.dart';
import 'package:shiksha/SettingsViews/AboutUsView.dart';
import 'package:shiksha/SettingsViews/PrivacyPolicyView.dart';
import 'package:shiksha/colors/colors.dart';

import '../AuthViews/ForgotPasswordView.dart';
import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import 'T&CView.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: PrimaryDarkColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: CustomText(
              text: "Settings", textSize: 18, color: PrimaryDarkColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),        backgroundColor: PrimaryWhiteColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage("assets/images/logo_landscape.png"),
                    height: 120,
                    width: 120,
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(text: "Account", textSize: 16, color: PrimaryDarkColor),
                            ],
                          ),

                          Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ForgotPasswordView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.lock,
                                  color: PrimaryDarkColor,
                                ),
                                CustomText(text: "Change Account Password", textSize: 16, color: PrimaryDarkColor),
                                Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TCView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.foodAppleOutline ,
                                  color: PrimaryDarkColor,
                                ),
                                CustomText(text: "Terms and Conditions", textSize: 16, color: PrimaryDarkColor),
                                Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PrivacyPolicyView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.serverSecurity,
                                  color: PrimaryDarkColor,
                                ),
                                CustomText(text: "Privacy Policy", textSize: 16, color: PrimaryDarkColor),
                                Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>AboutUsView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.informationOutline,
                                  color: PrimaryDarkColor,
                                ),
                                CustomText(text: "About Us", textSize: 16, color: PrimaryDarkColor),
                                Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 50, thickness: 2,),

                          CustomButton(
                              text: "LOG OUT",
                              buttonSize: 60,
                              context: context,
                              function: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>SignInView()));
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
