import 'package:animated_text_kit/animated_text_kit.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerImage(),
              Image(
                image: AssetImage("assets/images/intro.gif"),
                height: 300,
                width: 300,
              ),
              SizedBox(
                child: DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'ProductSans-Bold',
                      color: primaryDarkColor),
                  child: AnimatedTextKit(
                    pause: Duration(milliseconds: 3000),
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    animatedTexts: [
                      TypewriterAnimatedText('< code > Hello < /code>'),
                      TypewriterAnimatedText('Hunt a Job...'),
                      TypewriterAnimatedText('Access to College Library.'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
                child: CustomButton(
                    text: "Get Started",
                    buttonSize: 60,
                    context: context,
                    function: () {
                      Navigator.of(context)
                          .push(animatedRoute(const CollegeSelectView(
                        isUpdate: false,
                      )));
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
