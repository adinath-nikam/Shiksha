import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class LibraryHistoryView extends StatelessWidget {
  final String libraryBooksIssueHistory;

  const LibraryHistoryView({Key? key, required this.libraryBooksIssueHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: appBarCommon(context, "HISTORY")),
            body: libraryBooksIssueHistory != null
                ? Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                              child: HtmlWidget(
                                  onLoadingBuilder: (context, element, loadingProgress) {
                                    return progressIndicator();
                                  },
                                  "<table border='1' cellpadding='15'>$libraryBooksIssueHistory</table>"))),
                    ),
                  )
                : Center(
                    child: customTextBold(
                        text: 'No Books Circulation...',
                        textSize: 18,
                        color: primaryDarkColor),
                  )));
  }
}
