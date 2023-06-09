import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';

import '../colors/colors.dart';

class WorkDetailView extends StatefulWidget {
  const WorkDetailView({Key? key}) : super(key: key);

  @override
  State<WorkDetailView> createState() => _WorkDetailViewState();
}

class _WorkDetailViewState extends State<WorkDetailView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: PrimaryWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: PrimaryDarkColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227",
                  fit: BoxFit.fill,
                  height: 55,
                  width: 55,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),


              SizedBox(height: 25,),


              CustomText(text: "Graduate Engineer Trainee", textSize: 24, color: PrimaryDarkColor),
              SizedBox(height: 10,),
              CustomText(text: "Google", textSize: 20, color: PrimaryDarkColor.withAlpha(80)),

              SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: CustomText(
                    text: "Full Time",
                    textSize: 12,
                    color: PrimaryDarkColor),
              ),


              SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(MdiIcons.cash, color: PrimaryDarkColor,),
                    SizedBox(width: 10,),
                    CustomText(
                        text: "50-100 LPA",
                        textSize: 12,
                        color: PrimaryDarkColor),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(MdiIcons.mapMarkerOutline, color: PrimaryDarkColor,),
                    SizedBox(width: 10,),
                    CustomText(
                        text: "India",
                        textSize: 12,
                        color: PrimaryDarkColor),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              CustomText(text: "We are looking for an IT Analyst to design and implement functional and cost-efficient IT systems. IT Analyst responsibilities include prioritizing user requirements, overseeing system upgrades and researching new tools. In this role, you should be highly analytical and able to understand business needs. Excellent communication skills and problem-solving abilities are essential. If you also have hands-on experience with technical projects, we’d like to meet you. Your goal will be to leverage tech solutions to meet organizational needs.", textSize: 14, color: PrimaryDarkColor),

              SizedBox(height: 20,),

              CustomButton(text: "APPLY", buttonSize: 55, context: context, function: (){

                try {
                  launch('https://github.com');
                } catch (e) {
                  debugPrint(e.toString());
                }

              })

            ],


          ),
        ),
      ),
    ));
  }
}
