import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';

class LibraryIssuedBooksView extends StatelessWidget {
  final List issuedBooksList;

  const LibraryIssuedBooksView({Key? key, required this.issuedBooksList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: PrimaryWhiteColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: customAppBar(context, "ISSUED BOOKS")),
          body: issuedBooksList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: issuedBooksList.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(issuedBooksList[index]['issuedBookTitle']),
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
                                "${issuedBooksList[index]['issuedBookTitle']}",
                            textSize: 18,
                            color: PrimaryWhiteColor),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Authors: ${issuedBooksList[index]['issuedBookAuthor']}",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  color: PrimaryWhiteColor),
                            ),
                            Divider(
                              height: 30,
                              color: PrimaryWhiteColor,
                            ),
                            CustomTextRegular(
                                text:
                                    "Issue Date:\t\t\t${issuedBooksList[index]['bookIssueDate']}",
                                textSize: 14,
                                color: PrimaryWhiteColor),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextRegular(
                                text:
                                    "Due Date:\t\t\t${issuedBooksList[index]['bookDueDate']}",
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
                              child: CustomText(
                                  text: issuedBooksList[index]
                                      ['issuedBookLibrary'],
                                  textSize: 10,
                                  color: PrimaryDarkColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CustomText(
                      text: 'No Issued Books...',
                      textSize: 18,
                      color: PrimaryDarkColor),
                )),
    );
  }
}
