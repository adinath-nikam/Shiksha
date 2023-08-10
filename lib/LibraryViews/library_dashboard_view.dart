import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiksha/LibraryViews/library_book_search_view.dart';
import 'package:shiksha/LibraryViews/library_fines_view.dart';
import 'package:shiksha/LibraryViews/library_history_view.dart';
import 'package:shiksha/LibraryViews/library_issued_books_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:html/parser.dart' show parse;
import 'package:xml/xml.dart' as xml;
import 'package:requests/requests.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:firebase_database/firebase_database.dart';

class LibraryMenuItems {
  late final String title;
  late final Icon img;
  late final Widget Activity;

  LibraryMenuItems(
      {required this.title, required this.img, required this.Activity});
}

class LibraryDashboardView extends StatefulWidget {
  late final String appUserUSN;

  LibraryDashboardView({Key? key, required this.appUserUSN}) : super(key: key);

  @override
  State<LibraryDashboardView> createState() => _LibraryDashboardViewState();
}

class _LibraryDashboardViewState extends State<LibraryDashboardView> {
  late final Map collegeLibraryCreds;
  String _scanBarcode = 'Unknown';
  String username = 'Not Defined';
  String category = 'Not Defined';
  String stream = 'Not Defined';
  String gender = 'Not Defined';
  String fine = 'Not Defined';
  String email = 'Not Defined';
  String phone = 'Not Defined';
  String lhd = "Undefined";
  late dynamic patronImage;
  List fines = [];
  List loans = [];
  late final Future<bool> httpFuture;

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // httpClient(barcodeScanRes.toUpperCase());
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      widget.appUserUSN = _scanBarcode;
      httpClient(widget.appUserUSN);
    });
  }

  Future<bool> libraryAppAdminAuth() async {
    String libraryURL = await getCollegeLibraryURL();
    var responseAppAdminAuth = await Requests.get(libraryURL);
    final String responseString =
        xml.XmlDocument.parse(responseAppAdminAuth.body)
            .getElement("response")!
            .getElement('status')!
            .innerText;
    if (responseAppAdminAuth.statusCode == 200 && responseString == 'ok') {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getPatronID(
      String patronUserID, String patronUserPassword) async {
    // var responsePatronID = await Requests.get(
    //     'http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=AuthenticatePatron&username=$patronUserID&password=$patronUserPassword');

    var responsePatronID = await Requests.get(
        'http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=LookupPatron&id=$patronUserID&id_type=cardnumber');

    final String? responsePatronIDString =
        xml.XmlDocument.parse(responsePatronID.body)
            .getElement("LookupPatron")
            ?.getElement('id')
            ?.innerText;

    if (responsePatronIDString != null) {
      return responsePatronIDString;
    } else {
      return 'Patron Not Found';
    }
  }

  Future<bool> httpClient(String appUserUSN) async {
    if (await libraryAppAdminAuth()) {
      String? patronID = await getPatronID(appUserUSN, appUserUSN);

      if (patronID != 'Patron Not Found') {
        var responsePatronInfo = await Requests.get(
            'http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=GetPatronInfo&patron_id=$patronID&show_fines=1&show_loans=1');
        var responsePatronReadingHistory = await Requests.get(
            'http://103.139.157.231:8080/cgi-bin/koha/members/readingrec.pl?borrowernumber=$patronID');

        dynamic responsePatronImage = await Requests.get(
            'http://103.139.157.231:8080/cgi-bin/koha/members/patronimage.pl?borrowernumber=$patronID');

        final document = xml.XmlDocument.parse(responsePatronInfo.body);
        final document1 = parse(responsePatronReadingHistory.body)
            .getElementById("table_readingrec")!
            .innerHtml;

        final rootNode = document.getElement('GetPatronInfo');
        final finesChildElements = rootNode?.getElement('fines')?.childElements;
        final loansChildElements = rootNode?.getElement('loans')?.childElements;

        finesChildElements?.forEach((element) {
          element.getElement('status')?.innerText == 'RETURNED' ||
                  element.getElement('status')?.innerText == 'UNRETURNED'
              ? fines.add({
                  'finedBokTitle': element.getElement('description')?.innerText,
                  'finedBookStatus': element.getElement('status')?.innerText,
                  'finedBookAmount': element.getElement('amount')?.innerText,
                  'finedBookAmountOutstanding':
                      element.getElement('amountoutstanding')?.innerText,
                  'finedBookIssueDate': element.getElement('date')?.innerText,
                  'finedBookTimestamp':
                      element.getElement('timestamp')?.innerText,
                  'finedBookIssueId': element.getElement('issue_id')?.innerText,
                })
              : null;
        });

        loansChildElements?.forEach((element) {
          loans.add({
            'issuedBookTitle': element.getElement('title')?.innerText,
            'bookIssueDate': element.getElement('issuedate')?.innerText,
            'bookDueDate': element.getElement('date_due')?.innerText,
            'issuedBookLibrary': element.getElement('location')?.innerText,
            'issuedBookAuthor': element.getElement('author')?.innerText,
          });
        });

        setState(() {
          username = document
              .getElement("GetPatronInfo")!
              .getElement('surname')!
              .innerText
              .toUpperCase();
          gender = document
              .getElement("GetPatronInfo")!
              .getElement('sex')!
              .innerText
              .toUpperCase();
          stream = document
              .getElement("GetPatronInfo")!
              .getElement('sort1')!
              .innerText
              .toUpperCase();
          fine = document
              .getElement("GetPatronInfo")!
              .getElement('charges')!
              .innerText;
          email = document
              .getElement("GetPatronInfo")!
              .getElement('email')!
              .innerText;
          phone = document
              .getElement("GetPatronInfo")!
              .getElement('mobile')!
              .innerText;
          _scanBarcode = document
              .getElement("GetPatronInfo")!
              .getElement('cardnumber')!
              .innerText
              .toUpperCase();
          category = document
                      .getElement("GetPatronInfo")!
                      .getElement('categorycode')!
                      .innerText
                      .toUpperCase() ==
                  'ST'
              ? "STUDENT"
              : "STAFF";
          lhd = document1;
          patronImage = responsePatronImage.bodyBytes;
        });

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> getCollegeLibraryURL() async {
    late Map mapLibraryURL;
    await FirebaseDatabase.instance
        .ref('SHIKSHA_APP/COLLEGE_LIBRARY_CREDS/${modelUserData.getUserCollege}')
        .once()
        .then((value) {
      mapLibraryURL = value.snapshot.value as Map;
    });
    return mapLibraryURL['URL'];
  }

  @override
  void initState() {
    super.initState();
    httpFuture = httpClient(widget.appUserUSN);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "LIBRARY")),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            barcodeScan();
          },
          label: customTextBold(
              text: "Scan ID", textSize: 16, color: primaryWhiteColor),
          backgroundColor: primaryDarkColor,
          icon: Icon(
            Icons.barcode_reader,
            color: primaryWhiteColor,
          ),
        ),
        body: FutureBuilder<bool>(
          future: httpFuture,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return progressIndicator();
            } else if (snapshot.hasData && snapshot.data == true) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: AnimationLimiter(
                  child: AnimationConfiguration.synchronized(
                      child: SlideAnimation(
                    verticalOffset: MediaQuery.of(context).size.height,
                    child: Container(
                      child: libraryInfo(),
                    ),
                  )),
                ),
              );
            } else if (snapshot.hasData && snapshot.data == false) {
              return Center(
                child: customTextBold(
                    text: "No Patron Found! with UID \n'${widget.appUserUSN}'",
                    textSize: 22,
                    color: primaryDarkColor),
              );
            } else {
              return const Text("Error");
            }
          },
        ),
      ),
    );
  }

  Widget libraryInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            width: double.infinity,
            color: primaryDarkColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: 100,
                    height: 100,
                    image: Image.memory(patronImage).image,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                customTextRegular(
                    text: "Total Due (Fine to Pay)",
                    textSize: 14,
                    color: primaryWhiteColor),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      color: primaryWhiteColor,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    customTextBold(
                        text: fine, textSize: 30, color: primaryWhiteColor),
                  ],
                ),
                Divider(
                  color: primaryWhiteColor,
                  thickness: 1,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: primaryWhiteColor.withOpacity(0.5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: customTextBold(
                      text: username, textSize: 24, color: primaryWhiteColor),
                ),
              ],
            ),
          ),
          libraryMenu(context),
        ],
      ),
    );
  }

  Widget libraryMenu(BuildContext context) {
    LibraryMenuItems item1 = LibraryMenuItems(
        title: "SEARCH",
        img: Icon(
          Icons.search_rounded,
          color: primaryDarkColor,
          size: 25,
        ),
        Activity: LibraryBookSearchView());

    LibraryMenuItems item2 = LibraryMenuItems(
        title: "FINES",
        img: Icon(
          Icons.currency_rupee_rounded,
          color: primaryDarkColor,
          size: 25,
        ),
        Activity: LibraryFinesView(
          booksFinesList: fines,
        ));

    LibraryMenuItems item3 = LibraryMenuItems(
        title: "BOOKS",
        img: Icon(
          Icons.my_library_books_rounded,
          color: primaryDarkColor,
          size: 25,
        ),
        Activity: LibraryIssuedBooksView(
          issuedBooksList: loans,
        ));

    LibraryMenuItems item4 = LibraryMenuItems(
        title: "HISTORY",
        img: Icon(
          Icons.history_rounded,
          color: primaryDarkColor,
          size: 25,
        ),
        Activity: LibraryHistoryView(
          libraryBooksIssueHistory: lhd,
        ));

    List<LibraryMenuItems> LibraryMenuItemsList = [
      item1,
      item2,
      item3,
      item4,
    ];

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            customTextBold(
                text: "Operation", textSize: 22, color: primaryDarkColor),
            SizedBox(
              height: 20,
            ),
            GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.0,
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                children: LibraryMenuItemsList.map((data) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(animatedRoute(data.Activity));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          color: primaryDarkColor,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: primaryWhiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            data.img,
                            customTextBold(
                                text: data.title,
                                textSize: 14,
                                color: primaryDarkColor)
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList())
          ],
        ),
      ),
    );
  }
}
