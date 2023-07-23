import 'package:flutter/material.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class LibraryFinesView extends StatelessWidget {
  final List booksFinesList;
  const LibraryFinesView({Key? key, required this.booksFinesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryWhiteColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: appBarCommon(context, "FINES")),
          body: booksFinesList.isNotEmpty
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: booksFinesList.length,
              itemBuilder: (context, index) => Card(
                key: ValueKey(booksFinesList[index]['issuedBookTitle']),
                margin: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                color: primaryDarkColor.withOpacity(0.8),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Icon(
                    Icons.book_rounded,
                    size: 40,
                    color: primaryWhiteColor,
                  ),
                  title: customTextRegular(
                      text:
                      "${booksFinesList[index]['finedBokTitle']}",
                      textSize: 18,
                      color: primaryWhiteColor),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 30,
                        color: primaryWhiteColor,
                      ),
                      customTextRegular(
                          text:
                          "Issue Date:\t\t\t${booksFinesList[index]['finedBookIssueDate']}",
                          textSize: 14,
                          color: primaryWhiteColor),
                      const SizedBox(
                        height: 5,
                      ),
                      customTextRegular(
                          text:
                          "Due Date:\t\t\t${booksFinesList[index]['finedBookIssueDate']}",
                          textSize: 14,
                          color: primaryWhiteColor),
                      Divider(
                        height: 30,
                        color: primaryWhiteColor,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryWhiteColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                             Icons.currency_rupee_rounded,
                              color: primaryRedColor,
                            ),
                            const SizedBox(width: 10,),
                            customTextBold(text: booksFinesList[index]['finedBookAmount'], textSize: 18, color: primaryRedColor)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryWhiteColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bookmark_rounded,
                              color: primaryDarkColor,
                            ),
                            const SizedBox(width: 10,),
                            customTextBold(text: booksFinesList[index]['finedBookStatus'], textSize: 18, color: primaryDarkColor)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : Center(
            child: customTextBold(
                text: 'No Fined Books...',
                textSize: 18,
                color: primaryDarkColor),
          )),
    );
  }
}
