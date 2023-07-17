import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shiksha/colors/colors.dart';
import '../../../../Components/common_component_widgets.dart';
import '../../../../FirebaseServices/firebase_api.dart';
import '../../models/model_category.dart';
import '../widgets/quiz_options.dart';

class TriviaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "TRIVIA")),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            children: [
              infoWidget(
                  "Select Trivia Category.",
                  "Many Categories wil be added soon 😉...",
                  primaryDarkColor,
                  primaryGreenColor),
              SizedBox(height: 20,),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseAPI()
                        .realtimeDBStream("SHIKSHA_APP/OPEN_TRIVIA/CATEGORIES"),
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return progressIndicator();
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        list = map.values.toList();
                        return AnimationLimiter(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 20,
                                maxCrossAxisExtent: 200,
                              ),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, index) {
                                return AnimationConfiguration.staggeredGrid(
                                  duration: const Duration(milliseconds: 1000),
                                  position: index,
                                  columnCount: 2,
                                  child: SlideAnimation(
                                    verticalOffset:
                                        MediaQuery.of(context).size.height,
                                    child: Container(
                                      height: 150.0,
                                      width: 150.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primaryDarkColor.withAlpha(50),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SvgPicture.network(
                                            list[index]['ICON_URL'],
                                            semanticsLabel: 'trivia category icon',
                                            height: 60,
                                            width: 60,
                                            placeholderBuilder:
                                                (BuildContext context) => Container(
                                                    padding:
                                                        const EdgeInsets.all(30.0),
                                                    child: progressIndicator()),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Category category = Category(
                                                  list[index]['ID'],
                                                  list[index]['CATEGORY']);
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (sheetContext) =>
                                                    BottomSheet(
                                                  builder: (_) => TriviaOptionsDialog(
                                                    category: category,
                                                  ),
                                                  onClosing: () {},
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryDarkColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15), // <-- Radius
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
