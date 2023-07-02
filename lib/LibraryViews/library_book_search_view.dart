import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' show parse;

class _ModelSearchByOptions {
  late String searchByOptionTitle;
  late String searchByOptionCode;

  _ModelSearchByOptions(
      {required this.searchByOptionTitle, required this.searchByOptionCode});
}

class LibraryBookSearchView extends StatefulWidget {
  const LibraryBookSearchView({Key? key}) : super(key: key);

  @override
  State<LibraryBookSearchView> createState() => _LibraryBookSearchViewState();
}

class _LibraryBookSearchViewState extends State<LibraryBookSearchView> {
  String searchResultText = 'Search Library Books...';

  late List listBookSearchResult = [];
  late List tempListBookSearchResult = [];

  String searchByOptionTitleSelected = 'Title';
  String searchByOptionCodeSelected = 'ti';

  final List<_ModelSearchByOptions> _listSearchByOptions = [
    _ModelSearchByOptions(
      searchByOptionTitle: 'Title',
      searchByOptionCode: 'ti',
    ),
    _ModelSearchByOptions(
      searchByOptionTitle: 'Author',
      searchByOptionCode: 'au',
    ),
    _ModelSearchByOptions(
      searchByOptionTitle: 'Subject',
      searchByOptionCode: 'su',
    ),
    _ModelSearchByOptions(
      searchByOptionTitle: 'ISBN',
      searchByOptionCode: 'nb',
    ),
    _ModelSearchByOptions(
      searchByOptionTitle: 'Series',
      searchByOptionCode: 'se',
    ),
  ];

  searchByOptionsDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: customTextBold(
                text: 'Search by', textSize: 18, color: primaryDarkColor),
            content: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _listSearchByOptions
                          .map((option) => RadioListTile(
                                title: customTextRegular(
                                    text: option.searchByOptionTitle,
                                    textSize: 14,
                                    color: primaryDarkColor),
                                value: option.searchByOptionTitle,
                                onChanged: (value) {
                                  setState(() {
                                    searchByOptionTitleSelected =
                                        option.searchByOptionTitle;
                                    searchByOptionCodeSelected =
                                        option.searchByOptionCode;
                                  });
                                },
                                groupValue: searchByOptionTitleSelected,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ));
      });

  Future<void> searchBook(String searchText) async {
    setState(() {
      listBookSearchResult.clear();
      searchResultText = 'Searching...';
    });

    var responseBookSearch = await Requests.get(
        'http://103.139.157.231:8080/cgi-bin/koha/catalogue/search.pl?count=25&sort_by=title_az&idx=$searchByOptionCodeSelected&q=$searchText');

    final bookTitleList =
        parse(responseBookSearch.body).getElementsByClassName("title");

    final bookAuthorList =
        parse(responseBookSearch.body).getElementsByClassName("author");

    final bookAvailabilityList =
        parse(responseBookSearch.body).getElementsByClassName("availability");

    final bookLibraryList = parse(responseBookSearch.body)
        .getElementsByClassName("available_items_loop_items");

    for (final pairs in IterableZip([
      bookTitleList,
      bookAuthorList,
      bookAvailabilityList,
      bookLibraryList
    ])) {
      tempListBookSearchResult.add({
        'bookTitle': pairs[0].text.trim(),
        'bookAuthors': pairs[1].text.trim(),
        'bookAvailability': pairs[2].text.trim(),
        'bookLibrary': pairs[3].text.trim()
      });
    }

    setState(() {
      if (tempListBookSearchResult.isEmpty) {
        searchResultText = "No Books Found :(";
      } else {
        listBookSearchResult = tempListBookSearchResult;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: appBarCommon(context, "SEARCH BOOKS")),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          color: primaryDarkColor,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            color: primaryDarkColor,
                            onPressed: () {
                              searchByOptionsDialog(context);
                            },
                            tooltip: 'Search by',
                            icon: Icon(
                              Icons.sort_rounded,
                              color: primaryWhiteColor,
                            ),
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Search Books here...',
                        suffixIcon: Container(
                            color: primaryDarkColor,
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              color: primaryDarkColor,
                              onPressed: () {
                                searchBook(textController.text.toString());
                              },
                              tooltip: 'Search',
                              icon: Icon(
                                Icons.search_rounded,
                                color: primaryWhiteColor,
                              ),
                            )),
                      ),
                    ),
                  ),
                  listBookSearchResult.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: listBookSearchResult.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(
                                  listBookSearchResult[index]['bookTitle']),
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
                                        "${listBookSearchResult[index]['bookTitle']}",
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
                                      "Authors: ${listBookSearchResult[index]['bookAuthors']}",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: primaryWhiteColor),
                                    ),
                                    Divider(
                                      height: 30,
                                      color: primaryWhiteColor,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: primaryWhiteColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: customTextBold(
                                              text: listBookSearchResult[index]
                                                          ['bookAvailability']
                                                      .toString()
                                                      .toUpperCase()
                                                      .contains('AVAILABLE')
                                                  ? 'AVAILABLE'
                                                  : 'UNAVAILABLE',
                                              textSize: 10,
                                              color: primaryDarkColor),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: primaryWhiteColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: primaryWhiteColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: customTextBold(
                                              text: listBookSearchResult[index]
                                                          ['bookLibrary']
                                                      .toString()
                                                      .toUpperCase()
                                                      .contains(
                                                          'CENTRAL LIBRARY')
                                                  ? 'CENTRAL LIBRARY'
                                                  : 'STUDENT LENDING LIBRARY',
                                              textSize: 10,
                                              color: primaryDarkColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(100),
                          child: customTextBold(
                              text: searchResultText,
                              textSize: 18,
                              color: primaryDarkColor),
                        )
                ],
              ),
            )));
  }
}
