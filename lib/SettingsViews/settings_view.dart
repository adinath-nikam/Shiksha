import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/singin_view.dart';
import 'package:shiksha/SettingsViews/about_us_view.dart';
import 'package:shiksha/SettingsViews/privacy_policy_view.dart';
import 'package:shiksha/colors/colors.dart';
import '../AuthViews/forgot_password_view.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import 't&c_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "SETTINGS")),        backgroundColor: primaryWhiteColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage("assets/images/logo_landscape.png"),
                    height: 120,
                    width: 120,
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextBold(text: "Account", textSize: 16, color: primaryDarkColor),
                            ],
                          ),

                          const Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ForgotPasswordView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.lock,
                                  color: primaryDarkColor,
                                ),
                                customTextBold(text: "Change Account Password", textSize: 16, color: primaryDarkColor),
                                const Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const TCView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.foodAppleOutline ,
                                  color: primaryDarkColor,
                                ),
                                customTextBold(text: "Terms and Conditions", textSize: 16, color: primaryDarkColor),
                                const Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const PrivacyPolicyView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.serverSecurity,
                                  color: primaryDarkColor,
                                ),
                                customTextBold(text: "Privacy Policy", textSize: 16, color: primaryDarkColor),
                                const Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 50, thickness: 2,),


                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const AboutUsView())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  MdiIcons.informationOutline,
                                  color: primaryDarkColor,
                                ),
                                customTextBold(text: "About Us", textSize: 16, color: primaryDarkColor),
                                const Icon(
                                  MdiIcons.chevronRight,
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 50, thickness: 2,),

                          CustomButton(
                              text: "LOG OUT",
                              buttonSize: 60,
                              context: context,
                              function: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const SignInView()));
                              }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                  madeInTAG(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
