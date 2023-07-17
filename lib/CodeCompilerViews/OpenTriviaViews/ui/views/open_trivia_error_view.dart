import 'package:flutter/material.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/colors/colors.dart';

import '../../../../Components/common_component_widgets.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, this.message = "There was an unknown error."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "ERROR")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    customTextRegular(text: message, textSize: 18, color: primaryRedColor),


                    SizedBox(height: 20.0),

                    CustomButton(text: "Try Again", buttonSize: 60, context: context, function: (){
                      Navigator.pop(context);
                    })

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
