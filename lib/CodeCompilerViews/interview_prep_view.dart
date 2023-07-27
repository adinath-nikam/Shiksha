import 'package:flutter/material.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/ui/views/open_trivia_home_view.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';
import 'Top100CodesViews/Top100CodesTabBarView.dart';

class InterviewPrepView extends StatefulWidget {
  const InterviewPrepView({Key? key}) : super(key: key);

  @override
  State<InterviewPrepView> createState() => _InterviewPrepViewState();
}

class _InterviewPrepViewState extends State<InterviewPrepView> with AutomaticKeepAliveClientMixin<InterviewPrepView> {

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: infoWidget(
                    "Welcome to Shiksha Placement Preparation 🎊",
                    "Interview Preparation Tips & Tricks.",
                    primaryDarkColor,
                    primaryGreenColor.withOpacity(0.5))),
            InterviewMenuView(context),
          ],
        ),
      ),
    ));
  }

  Widget InterviewMenuView(BuildContext context) {
    InterviewMenuItems item1 = InterviewMenuItems(
        text: "Free Aptitude Tests and Quiz!.",
        img: Image(
          image: AssetImage("assets/images/aptitude_img.png"),
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        activity: TriviaHomePage());

    InterviewMenuItems item2 = InterviewMenuItems(
        text: "Top 100 Coding Questions which is asked in Technical Interviews.",
        img: Image(
          image: AssetImage("assets/images/top100codes_img.png"),
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        activity: Top100CodesTabBarView());


    List<InterviewMenuItems> expansionMenuItemsList = [
      item1,
      item2,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.count(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          childAspectRatio: 0.85,
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          children: expansionMenuItemsList.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(animatedRoute(data.activity));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: primaryDarkColor.withOpacity(1),
                  elevation: 2,
                  child: Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryWhiteColor,
                    ),
                    margin: EdgeInsets.all(2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data.img,
                        SizedBox(height: 5),
                        customTextRegular(
                            text: data.text,
                            textSize: 10,
                            color: primaryDarkColor.withOpacity(0.5)),
                      ],
                    ),
                  )),
            );
          }).toList()),
    );
  }
}

class InterviewMenuItems {
  late String text;
  late Image img;
  late Widget activity;

  InterviewMenuItems(
      {required this.text, required this.img, required this.activity});
}
