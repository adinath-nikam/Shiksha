import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/college_select_view.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Editors/profile_edit_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/colors/colors.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "PROFILE")),
      body: const ProfileViewContent(),
    ));
  }
}

class ProfileViewContent extends StatefulWidget {
  const ProfileViewContent({Key? key}) : super(key: key);

  @override
  State<ProfileViewContent> createState() => _ProfileViewContentState();
}

class _ProfileViewContentState extends State<ProfileViewContent> {
  final double circleRadius = 120.0;

  @override
  void initState() {
    super.initState();
  }

  Widget isVerified() {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      return Icon(MdiIcons.checkDecagramOutline,
          size: 24, color: primaryLightBlueColor);
    } else {
      return Icon(MdiIcons.alertDecagramOutline,
          size: 24, color: primaryRedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: circleRadius / 2.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 25),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: circleRadius / 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const EditProfileView()));
                                    },
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const CollegeSelectView()));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          customTextBold(
                                              text: 'EDIT',
                                              textSize: 16,
                                              color: primaryLightBlueColor),
                                          Icon(
                                            Icons.settings,
                                            color: primaryLightBlueColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: customTextBold(
                                              text: modelUserData.getUserUSN,
                                              textSize: 24,
                                              color: primaryDarkColor),
                                        ),
                                      ),

                                      // isVerified(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: modelUserData.getUserUID));
                                      showSnackBar(
                                          context,
                                          "User ID Copied to Clipboard.",
                                          primaryGreenColor);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                            child: customTextRegular(
                                                text: modelUserData.getUserUID,
                                                textSize: 10,
                                                color: primaryDarkColor)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          MdiIcons.contentCopy,
                                          size: 15,
                                          color: primaryDarkColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                MdiIcons.schoolOutline,
                                                size: 30,
                                                color: primaryDarkColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: customTextBold(
                                                    text: modelUserData
                                                        .getUserCollege,
                                                    textSize: 16,
                                                    color: primaryDarkColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                MdiIcons.bookEducationOutline,
                                                size: 30,
                                                color: primaryDarkColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: customTextBold(
                                                    text: modelUserData
                                                        .getUserStream,
                                                    textSize: 16,
                                                    color: primaryDarkColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                MdiIcons.calendarAccountOutline,
                                                size: 30,
                                                color: primaryDarkColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: customTextBold(
                                                    text: modelUserData
                                                        .getUserSemester,
                                                    textSize: 16,
                                                    color: primaryDarkColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 30,
                                          indent: 20,
                                          endIndent: 20,
                                          color: primaryDarkColor,
                                          thickness: 1,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        SizedBox(
                                          height: 80,
                                          child: SfBarcodeGenerator(
                                            value: modelUserData.getUserUSN
                                                .toUpperCase(),
                                            showValue: true,
                                            textStyle: const TextStyle(
                                                fontFamily: "ProductSans-Bold"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(
                                    height: 10,
                                    indent: 20,
                                    endIndent: 20,
                                    color: primaryDarkColor,
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  customTextRegular(
                                      text:
                                          "Joined on: ${modelUserData.getUserJoiningDate}",
                                      textSize: 14,
                                      color: primaryDarkColor.withAlpha(100))
                                ],
                              )),
                        ),
                      ),

                      ///Image Avatar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: primaryDarkColor,
                                spreadRadius: 0)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: primaryDarkColor,
                          child: const Padding(
                            padding: EdgeInsets.all(8), // Border radius
                            child: ClipOval(
                              child: Image(
                                width: 60,
                                height: 60,
                                image: AssetImage('assets/images/1.png'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
