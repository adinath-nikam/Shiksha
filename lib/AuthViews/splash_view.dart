import 'package:flutter/material.dart';
import 'package:shiksha/AuthViews/profile_build_view.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/colors/colors.dart';

class IntroView extends StatelessWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerImage(),
                Image(
                  image: AssetImage("assets/images/splash_img.png"),
                  height: 400,
                  width: 400,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
                  child: CustomButton(
                      text: "GET STARTED",
                      buttonSize: 60,
                      context: context,
                      function: () {
                        Navigator.of(context)
                            .push(animatedRoute(const CollegeTypeSelectView(
                          isUpdate: false,
                        )));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
