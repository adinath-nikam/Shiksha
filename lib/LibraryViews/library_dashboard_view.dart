import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/LibraryViews/library_book_search_view.dart';
import 'package:shiksha/LibraryViews/library_fines_view.dart';
import 'package:shiksha/LibraryViews/library_history_view.dart';
import 'package:shiksha/LibraryViews/library_issued_books_view.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../BusTracking/bus_track_map_view.dart';
import '../ChatGPT/page/chat_gpt_home_Page.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:html/parser.dart' show parse;
import 'package:flip_card/flip_card.dart';
import 'package:xml/xml.dart' as xml;
import 'package:requests/requests.dart';

class LibraryMenuItems {
  late String title;
  late Icon img;
  late Widget Activity;

  LibraryMenuItems(
      {required this.title, required this.img, required this.Activity});
}

class LibraryDashboardView extends StatefulWidget {
  String appUserUSN;

  LibraryDashboardView({Key? key, required this.appUserUSN}) : super(key: key);

  @override
  State<LibraryDashboardView> createState() => _LibraryDashboardViewState();
}

class _LibraryDashboardViewState extends State<LibraryDashboardView> {
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
    var responseAppAdminAuth = await Requests.get(
        'http://103.139.157.231:8080/cgi-bin/koha/svc/authentication?userid=app_admin&password=admin@app1');
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

      print(patronID);

      if (patronID != 'Patron Not Found') {
        var responsePatronInfo = await Requests.get(
            'http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=GetPatronInfo&patron_id=$patronID&show_fines=1&show_loans=1');
        var responsePatronReadingHistory = await Requests.get(
            'http://103.139.157.231:8080/cgi-bin/koha/members/readingrec.pl?borrowernumber=$patronID');

        var responseBookSearch = await Requests.get(
            'http://103.139.157.231:8080/cgi-bin/koha/catalogue/search.pl?count=25&sort_by=title_az&idx=ti&q=Os');

        dynamic responsePatronImage = await Requests.get(
            'http://103.139.157.231:8080/cgi-bin/koha/members/patronimage.pl?borrowernumber=$patronID');

        // var r = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/svc/authentication?userid=app_admin&password=admin@app1');
        // var r1 = await Requests.get('http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=GetPatronInfo&patron_id=5396&show_fines=1&show_loans=1');
        // var r2 = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/members/readingrec.pl?borrowernumber=5396');
        // dynamic r3 = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/members/patronimage.pl?borrowernumber=5156');

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
            MdiIcons.barcodeScan,
            color: primaryWhiteColor,
          ),
        ),
        body: FutureBuilder<bool>(
          future: httpFuture,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    FlipCard(
                        fill: Fill.fillBack,
                        // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL,
                        // default
                        side: CardSide.FRONT,
                        // The side to initially display.
                        front: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryDarkColor,
                          ),
                          padding: EdgeInsets.all(2),
                          child: Card(
                            color: primaryWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: 50,
                                      imageUrl:
                                          'https://www.kletech.ac.in/information/img/logo.png',
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        MdiIcons.alertCircleOutline,
                                        color: primaryWhiteColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          height: 130,
                                          fit: BoxFit.fitHeight,
                                          image:
                                              Image.memory(patronImage).image,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: primaryDarkColor.withAlpha(
                                                  50),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: customTextBold(
                                                text: category,
                                                textSize: 14,
                                                color: primaryDarkColor),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          customTextBold(
                                              text: username,
                                              textSize: 22,
                                              color: primaryDarkColor),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 60,
                                            width: 180,
                                            child: SfBarcodeGenerator(
                                              symbology: Code128(),
                                              value: _scanBarcode,
                                              showValue: true,
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: "ProductSans-Bold",
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        back: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryDarkColor,
                          ),
                          padding: EdgeInsets.all(2),
                          child: Card(
                            color: primaryWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.schoolOutline,
                                        color: primaryDarkColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      customTextBold(
                                          text: stream,
                                          textSize: 16,
                                          color: primaryDarkColor)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.emailOutline,
                                        color: primaryDarkColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      customTextBold(
                                          text: email,
                                          textSize: 16,
                                          color: primaryDarkColor)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.phone,
                                        color: primaryDarkColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      customTextBold(
                                          text: phone,
                                          textSize: 16,
                                          color: primaryDarkColor)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.humanMale,
                                        color: primaryDarkColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      customTextBold(
                                          text: gender,
                                          textSize: 16,
                                          color: primaryDarkColor)
                                    ],
                                  ),
                                  Divider(
                                    height: 50,
                                    color: primaryDarkColor,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        MdiIcons.currencyRupee,
                                        color: primaryRedColor,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      customTextBold(
                                          text: fine,
                                          textSize: 30,
                                          color: primaryRedColor)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    LibraryMenu(context),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data == false) {
              return Text("No Patron");
            } else {
              return Text("Error");
            }
          },
        ),
      ),
    );
  }

  Widget LibraryMenu(BuildContext context) {
    LibraryMenuItems item1 = LibraryMenuItems(
        title: "SEARCH",
        img: Icon(
          MdiIcons.bookSearchOutline,
          color: primaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryBookSearchView());

    LibraryMenuItems item2 = LibraryMenuItems(
        title: "FINES",
        img: Icon(
          MdiIcons.currencyRupee,
          color: primaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryFinesView(
          booksFinesList: fines,
        ));

    LibraryMenuItems item3 = LibraryMenuItems(
        title: "BOOKS",
        img: Icon(
          MdiIcons.bookshelf,
          color: primaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryIssuedBooksView(
          issuedBooksList: loans,
        ));

    LibraryMenuItems item4 = LibraryMenuItems(
        title: "HISTORY",
        img: Icon(
          MdiIcons.history,
          color: primaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryHistoryView(
          libraryBooksIssueHistory: lhd,
        ));


    LibraryMenuItems item5 = LibraryMenuItems(
        title: "ABOUT",
        img: Icon(
          MdiIcons.informationVariant,
          color: primaryWhiteColor,
          size: 25,
        ),
        Activity: MapScreenView());

    List<LibraryMenuItems> LibraryMenuItemsList = [
      item1,
      item2,
      item3,
      item4,
      item5
    ];

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: Column(
          children: <Widget>[
            GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.0,
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                children: LibraryMenuItemsList.map((data) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => data.Activity));
                    },
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: primaryDarkColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          data.img,

                          //SizedBox(height: 12.0,),
                          customTextBold(
                              text: data.title,
                              textSize: 14,
                              color: primaryWhiteColor)
                        ],
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
