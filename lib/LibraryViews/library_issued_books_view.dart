import 'package:flutter/material.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class LibraryIssuedBooksView extends StatelessWidget {
  final List issuedBooksList;

  const LibraryIssuedBooksView({Key? key, required this.issuedBooksList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryWhiteColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: appBarCommon(context, "ISSUED BOOKS")),
          body: issuedBooksList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: issuedBooksList.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(issuedBooksList[index]['issuedBookTitle']),
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
                                "${issuedBooksList[index]['issuedBookTitle']}",
                            textSize: 18,
                            color: primaryWhiteColor),
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
                                  color: primaryWhiteColor),
                            ),
                            Divider(
                              height: 30,
                              color: primaryWhiteColor,
                            ),
                            customTextRegular(
                                text:
                                    "Issue Date:\t\t\t${issuedBooksList[index]['bookIssueDate']}",
                                textSize: 14,
                                color: primaryWhiteColor),
                            const SizedBox(
                              height: 5,
                            ),
                            customTextRegular(
                                text:
                                    "Due Date:\t\t\t${issuedBooksList[index]['bookDueDate']}",
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
                              child: customTextBold(
                                  text: issuedBooksList[index]
                                      ['issuedBookLibrary'],
                                  textSize: 10,
                                  color: primaryDarkColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: customTextBold(
                      text: 'No Issued Books...',
                      textSize: 18,
                      color: primaryDarkColor),
                )),
    );
  }
}
