import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';

class LibraryFinesView extends StatelessWidget {
  final List booksFinesList;
  const LibraryFinesView({Key? key, required this.booksFinesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: PrimaryWhiteColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: customAppBar(context, "FINES")),
          body: booksFinesList.isNotEmpty
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: booksFinesList.length,
              itemBuilder: (context, index) => Card(
                key: ValueKey(booksFinesList[index]['issuedBookTitle']),
                margin: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                color: PrimaryDarkColor.withOpacity(0.8),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Icon(
                    MdiIcons.book,
                    size: 40,
                    color: PrimaryWhiteColor,
                  ),
                  title: CustomTextRegular(
                      text:
                      "${booksFinesList[index]['finedBokTitle']}",
                      textSize: 18,
                      color: PrimaryWhiteColor),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 30,
                        color: PrimaryWhiteColor,
                      ),
                      CustomTextRegular(
                          text:
                          "Issue Date:\t\t\t${booksFinesList[index]['finedBookIssueDate']}",
                          textSize: 14,
                          color: PrimaryWhiteColor),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextRegular(
                          text:
                          "Due Date:\t\t\t${booksFinesList[index]['finedBookIssueDate']}",
                          textSize: 14,
                          color: PrimaryWhiteColor),
                      Divider(
                        height: 30,
                        color: PrimaryWhiteColor,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryWhiteColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.currencyRupee,
                              color: PrimaryRedColor,
                            ),
                            const SizedBox(width: 10,),
                            CustomText(text: booksFinesList[index]['finedBookAmount'], textSize: 18, color: PrimaryRedColor)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryWhiteColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.bookmarkCheckOutline,
                              color: PrimaryDarkColor,
                            ),
                            const SizedBox(width: 10,),
                            CustomText(text: booksFinesList[index]['finedBookStatus'], textSize: 18, color: PrimaryRedColor)
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
            child: CustomText(
                text: 'No Fined Books...',
                textSize: 18,
                color: PrimaryDarkColor),
          )),
    );
  }
}
