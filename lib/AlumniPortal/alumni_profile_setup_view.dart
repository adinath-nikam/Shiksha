import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Components/constants.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:shiksha/Models/model_user_data.dart';

import '../Components/AuthButtons.dart';
import '../colors/colors.dart';

class AlumniProfileBuildView extends StatefulWidget {
  const AlumniProfileBuildView({Key? key}) : super(key: key);

  @override
  State<AlumniProfileBuildView> createState() => _AlumniProfileBuildViewState();
}

class _AlumniProfileBuildViewState extends State<AlumniProfileBuildView> {
  DateTime selectedYear = DateTime.now();
  bool cbWorkStatus = false;
  final GlobalKey<FormState> formKeyAlumniProfile = GlobalKey();
  final TextEditingController controllerTextEditBatchYear =
      TextEditingController();
  final TextEditingController controllerTextEditWorkStatus =
      TextEditingController();
  final TextEditingController controllerTextEditUsername =
      TextEditingController();
  final TextEditingController controllerTextEditUserEmail =
      TextEditingController();

  UserObject? user;
  bool logoutUser = false;

  @override
  void dispose() {
    super.dispose();
    controllerTextEditWorkStatus.dispose();
    controllerTextEditUserEmail.dispose();
    controllerTextEditUsername.dispose();
    controllerTextEditBatchYear.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, 'ALUMNI PROFILE')),
      backgroundColor: primaryWhiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5, color: primaryDarkColor, spreadRadius: 0)
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryDarkColor,
                child: Padding(
                  padding: EdgeInsets.all(0), // Border radius
                  child: ClipOval(
                    child: user?.profileImageUrl == null
                        ? Image.asset(
                            'assets/images/alumni_nil_icon.png',
                            height: 100,
                            width: 100,
                          )
                        : Image.network(
                            user!.profileImageUrl!,
                            fit: BoxFit.contain,
                            height: 100,
                            width: 100,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: progressIndicator(),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
            Form(
              key: formKeyAlumniProfile,
              child: Column(
                children: [
                  user != null
                      ? Column(
                          children: [
                            TextFormField(
                              enabled: false,
                              controller: controllerTextEditUsername,
                              decoration: InputDecoration(
                                hintText:
                                    user!.firstName! + ' ' + user!.lastName!,
                                prefixIcon: const Icon(
                                  Icons.person_2_rounded,
                                  color: primaryDarkColor,
                                ),
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
                              style: TextStyle(
                                  color: primaryDarkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'ProductSans-Bold'),
                              onSaved: (value) {},
                              validator: (value) {
                                return value == null ? '* Required' : null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: controllerTextEditUserEmail,
                              decoration: InputDecoration(
                                hintText: user!.email,
                                prefixIcon: const Icon(
                                  Icons.email_rounded,
                                  color: primaryDarkColor,
                                ),
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
                              style: TextStyle(
                                  color: primaryDarkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'ProductSans-Bold'),
                              onSaved: (value) {},
                              validator: (value) {
                                return value == null ? '* Required' : null;
                              },
                            )
                          ],
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: customTextBold(
                                text: 'Select your Batch..',
                                textSize: 18,
                                color: primaryDarkColor),
                            content: Container(
                              width: 300,
                              height: 300,
                              child: YearPicker(
                                firstDate:
                                    DateTime(DateTime.now().year - 30, 1),
                                lastDate: DateTime(DateTime.now().year + 5, 1),
                                selectedDate: selectedYear,
                                initialDate: selectedYear,
                                onChanged: (DateTime dateTime) {
                                  setState(() {
                                    controllerTextEditBatchYear.text =
                                        dateTime.year.toString();
                                    selectedYear = dateTime;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    controller: controllerTextEditBatchYear,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Batch Year...',
                      prefixIcon: const Icon(
                        Icons.calendar_month_rounded,
                        color: primaryDarkColor,
                      ),
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
                    style: TextStyle(
                        color: primaryDarkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'ProductSans-Bold'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Required.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    enabled: !cbWorkStatus,
                    controller: controllerTextEditWorkStatus,
                    decoration: InputDecoration(
                      hintText: "Where you Work..",
                      prefixIcon: const Icon(
                        Icons.work_rounded,
                        color: primaryDarkColor,
                      ),
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
                    style: TextStyle(
                        color: primaryDarkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'ProductSans-Bold'),
                    onSaved: (value) {},
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? '* Required'
                          : null;
                    },
                  ),
                  CheckboxListTile(
                    activeColor: primaryDarkColor,
                    title: customTextBold(
                        text: 'Not yet Working!',
                        textSize: 12,
                        color: primaryDarkColor),
                    subtitle: customTextBold(
                        text: '\'Student\' will be Showed as Work Status!',
                        textSize: 10,
                        color: primaryDarkColor.withOpacity(0.5)),
                    value: cbWorkStatus,
                    onChanged: (value) {
                      setState(() {
                        cbWorkStatus = value!;
                        controllerTextEditWorkStatus.text =
                            value ? 'Student' : '';
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            user == null
                ? SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            animatedRoute(
                              LinkedInUserWidget(
                                appBar: PreferredSize(
                                    preferredSize: const Size.fromHeight(60.0),
                                    child: appBarCommon(
                                        context, 'LinkedIn SignIn')),
                                destroySession: logoutUser,
                                redirectUrl:
                                    'https://www.linkedin.com/developers/tools/oauth/redirect',
                                clientId: '860l6uhjmpkro0',
                                clientSecret: 'gU6v1a89ohx9xgLq',
                                projection: const [
                                  ProjectionParameters.id,
                                  ProjectionParameters.localizedFirstName,
                                  ProjectionParameters.localizedLastName,
                                  ProjectionParameters.firstName,
                                  ProjectionParameters.lastName,
                                  ProjectionParameters.profilePicture,
                                ],
                                scope: const [
                                  EmailAddressScope(),
                                  LiteProfileScope(),
                                ],
                                onError: (final UserFailedAction e) {
                                  print('Error: ${e.toString()}');
                                  print('Error: ${e.stackTrace.toString()}');
                                },
                                onGetUserProfile:
                                    (final UserSucceededAction linkedInUser) {
                                  user = UserObject(
                                    firstName: linkedInUser
                                        .user.firstName?.localized?.label,
                                    lastName: linkedInUser
                                        .user.lastName?.localized?.label,
                                    email: linkedInUser.user.email?.elements
                                        ?.elementAt(0)
                                        .handleDeep
                                        ?.emailAddress,
                                    profileImageUrl: linkedInUser
                                                .user
                                                .profilePicture
                                                ?.displayImageContent
                                                ?.elements
                                                ?.elementAt(0)
                                                .identifiers
                                                ?.elementAt(0)
                                                .identifier ==
                                            null
                                        ? 'Nil'
                                        : linkedInUser.user.profilePicture
                                            ?.displayImageContent?.elements
                                            ?.elementAt(0)
                                            .identifiers
                                            ?.elementAt(0)
                                            .identifier,
                                  );

                                  setState(() {
                                    logoutUser = false;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDarkColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.linkedin,
                      ),
                      label: customTextBold(
                          text: 'LinkedIn Profile Access',
                          textSize: 16,
                          color: primaryWhiteColor),
                    ),
                  )
                : CustomButton(
                    text: 'Done',
                    buttonSize: 60,
                    context: context,
                    function: () {
                      if (formKeyAlumniProfile.currentState!.validate()) {
                        formKeyAlumniProfile.currentState!.save();
                        try {
                          showLoaderDialog(context, "Building Profile...");
                          FirebaseAPI()
                              .firebaseFirestore
                              .collection(DB_ROOT_NAME)
                              .doc(ALUMNI_CONSTANT)
                              .collection(modelUserData.getUserCollege)
                              .doc(controllerTextEditBatchYear.text.toString())
                              .set({
                            'batch_year':
                                controllerTextEditBatchYear.text.toString()
                          }).whenComplete(() {
                            FirebaseAPI()
                                .firebaseFirestore
                                .collection(DB_ROOT_NAME)
                                .doc(ALUMNI_CONSTANT)
                                .collection(modelUserData.getUserCollege)
                                .doc(
                                    controllerTextEditBatchYear.text.toString())
                                .collection(ALUMNI_CONSTANT_2)
                                .doc(modelUserData.getUserUID)
                                .set({
                              'user_name':
                                  user!.firstName! + ' ' + user!.lastName!,
                              'user_email': user!.email,
                              'work_status':
                                  controllerTextEditWorkStatus.text.toString(),
                              'profile_img_url': user!.profileImageUrl,
                              'user_stream': modelUserData.getUserStream,
                            }).whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          });
                        } catch (e) {}
                      }
                    }),
            SizedBox(
              height: 25,
            ),
            customTextRegular(
                text: 'Read Here. Shiksha App Privacy Policy on',
                textSize: 12,
                color: primaryDarkColor.withOpacity(0.5)),
            GestureDetector(
                onTap: () {
                  try {
                    launch(
                        'https://github.com/adinath-nikam/Shiksha-Documentation/blob/main/docs/alumni_linkedin_access_privacy_policy.md');
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: customTextBold(
                    text: 'LinkedIn Profile Access',
                    textSize: 12,
                    color: primaryBlueColor.withOpacity(1)))
          ]),
        ),
      ),
    ));
  }
}

class UserObject {
  UserObject({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}
