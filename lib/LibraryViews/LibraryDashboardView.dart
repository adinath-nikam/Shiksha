import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/LibraryViews/LibraryDashboardView.dart';
import 'package:shiksha/LibraryViews/LibraryFinesView.dart';
import 'package:shiksha/LibraryViews/LibraryHistoryView.dart';
import 'package:shiksha/LibraryViews/LibraryIssuedBooksView.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../BusTracking/MapView.dart';
import '../ChatGPT/page/HomePage.dart';
import '../Components/CommonComponentWidgets.dart';
import '../HomeView/HomeView.dart';
import '../colors/colors.dart';
import 'LibraryDashboardView.dart';
import 'LibraryDashboardView.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:http/http.dart' as http;
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
  const LibraryDashboardView({Key? key}) : super(key: key);

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

  // This list will be displayed in the ListView
  List fines = [];
  List loans = [];

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      // httpClient(barcodeScanRes, barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Future<void> httpClient(String userID, String password) async {
  //   var url1 = Uri.http('103.139.157.231', '/cgi-bin/koha/opac-user.pl');
  //   var url2 = Uri.http('103.139.157.231', '/cgi-bin/koha/opac-memberentry.pl');
  //
  //   var response1 =
  //       await http.post(url1, body: {'userid': userID, 'password': password});
  //   var response2 =
  //       await http.post(url2, body: {'userid': userID, 'password': password});
  //
  //   if (response1.statusCode == 200 && response2.statusCode == 200) {
  //     // var document = parse(response.body);
  //     // var priceElement = parse(response.body).getElementsByClassName("breadcrumb-item")[1].text;
  //
  //     // RegExp regexUsername = RegExp(
  //     //   '.*<span class="userlabel">(.*?)</span>.*',
  //     //   caseSensitive: false,
  //     //   multiLine: false,
  //     // );
  //
  //     RegExp regexFines = RegExp(
  //       '.*<li><a href="#opac-user-fines">(.*?)</a></li>.*',
  //       caseSensitive: false,
  //       multiLine: false,
  //     );
  //
  //     RegExp regexCategory = RegExp(
  //       '.*/.*(<li>                                                     <label for="borrower_categorycode" class="">(.*?)<input type="hidden" name="borrower_categorycode" value="ST" />                                                                                                      </li>).*/g.*',
  //       caseSensitive: false,
  //       multiLine: true,
  //     );
  //
  //     // var resUserID = regexUsername.allMatches(response.body).forEach((element) {
  //     //   setState(() {
  //     //     username = element.group(1).toString();
  //     //   });
  //     // });
  //
  //     var resFine = regexFines.allMatches(response1.body).forEach((element) {
  //       setState(() {
  //         username = parse(response1.body)
  //             .getElementsByClassName("breadcrumb-item")[1]
  //             .text
  //             .trim();
  //         category = parse(response2.body)
  //             .querySelector('[for="borrower_categorycode"]')!
  //             .text
  //             .trim();
  //         gender =
  //             parse(response2.body).querySelector('[checked="checked"]')!.id;
  //         email = parse(response2.body)
  //             .querySelector('[name="borrower_email"]')!
  //             .text;
  //         phone = parse(response2.body)
  //             .querySelector('[name="borrower_phone"]')!
  //             .text;
  //         fine = element.group(1).toString();
  //       });
  //     });
  //
  //     var resCategory =
  //         regexCategory.allMatches(response2.body).forEach((element) {
  //       setState(() {
  //         // username =  parse(response1.body).getElementsByClassName("breadcrumb-item")[1].text.trim();
  //         // category =  element.group(1).toString();
  //         // fine = element.group(1).toString();
  //       });
  //     });
  //
  //     // resUserID.forEach((m) {
  //     //   userid = m.group(1).toString();  // print area code
  //     //   print(m.group(1));  // print area code
  //     // });
  //     //
  //     // resFine.forEach((m) {
  //     //   fine = m.group(1).toString();
  //     //   print(m.group(1));  // print area code
  //     // });
  //
  //     // setState(() {
  //     //   username = userid;
  //     //   fine = userfine;
  //     // });
  //   }
  // }




  Future<void> httpClient2() async {

    
    var r = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/svc/authentication?userid=app_admin&password=admin@app1');
    var r1 = await Requests.get('http://103.139.157.231/cgi-bin/koha/ilsdi.pl?service=GetPatronInfo&patron_id=5396&show_fines=1&show_loans=1');
    var r2 = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/members/readingrec.pl?borrowernumber=5396');
    dynamic r3 = await Requests.get('http://103.139.157.231:8080/cgi-bin/koha/members/patronimage.pl?borrowernumber=5156');

    print(r3);


    final document = xml.XmlDocument.parse(r1.body);
    final document1 = parse(r2.body).getElementById("table_readingrec")!.innerHtml;
    // final document1 = parse(r2.body).getElementById("readingrec")!.innerHtml;


    final rootNode = document.getElement('GetPatronInfo');
    final finesChildElements = rootNode?.getElement('fines')?.childElements;
    final loansChildElements = rootNode?.getElement('loans')?.childElements;

    print(loansChildElements);

    finesChildElements?.forEach((element) {
      
      element.getElement('status')?.innerText == 'RETURNED' || element.getElement('status')?.innerText == 'UNRETURNED' ?
        fines.add({

          'finedBokTitle': element.getElement('description')?.innerText,
          'finedBookStatus' : element.getElement('status')?.innerText,
          'finedBookAmount' : element.getElement('amount')?.innerText,
          'finedBookAmountOutstanding' : element.getElement('amountoutstanding')?.innerText,
          'finedBookIssueDate' : element.getElement('date')?.innerText,
          'finedBookTimestamp' : element.getElement('timestamp')?.innerText,
          'finedBookIssueId' : element.getElement('issue_id')?.innerText,


        }): null;

    });

    loansChildElements?.forEach((element) {


        loans.add({

          'issuedBookTitle': element.getElement('title')?.innerText,
          'bookIssueDate' : element.getElement('issuedate')?.innerText,
          'bookDueDate' : element.getElement('date_due')?.innerText,
          'issuedBookLibrary' : element.getElement('location')?.innerText,
          'issuedBookAuthor' : element.getElement('author')?.innerText,
        });

    });

    print(fines.length);
    print(fines);


    // loop through the document and extract values
    // for (final fine in tempFines!) {
    //
    //   print(fine.getElement("fine")!.getElement('description')!.innerText);
    //
    //   fines.add({
    //
    //     'description': fine.getElement("fine")!.getElement('description')!.innerText,
    //     'status' : fine.getElement("fine")!.getElement('status')!.innerText,
    //     'amount' : fine.getElement("fine")!.getElement('amount')!.innerText,
    //     'amountoutstanding' : fine.getElement("fine")!.getElement('amountoutstanding')!.innerText,
    //     'date' : fine.getElement("fine")!.getElement('date')!.innerText,
    //     'timestamp' : fine.getElement("fine")!.getElement('timestamp')!.innerText,
    //
    //
    //   });
    //
    //   print(fines.length);
    //
    //
    //   // final name = employee.findElements('name').first.text;
    //   // final salary = employee.findElements('salary').first.text;
    //   // temporaryList.add({'name': name, 'salary': salary});
    // }




    setState(() {
      username = document.getElement("GetPatronInfo")!.getElement('surname')!.innerText.toUpperCase();
      gender = document.getElement("GetPatronInfo")!.getElement('sex')!.innerText.toUpperCase();
      stream = document.getElement("GetPatronInfo")!.getElement('sort1')!.innerText.toUpperCase();
      fine = document.getElement("GetPatronInfo")!.getElement('charges')!.innerText;
      email = document.getElement("GetPatronInfo")!.getElement('email')!.innerText;
      phone = document.getElement("GetPatronInfo")!.getElement('mobile')!.innerText;
      _scanBarcode = document.getElement("GetPatronInfo")!.getElement('cardnumber')!.innerText.toUpperCase();
      category = document.getElement("GetPatronInfo")!.getElement('categorycode')!.innerText.toUpperCase() == 'ST' ? "STUDENT" : "STAFF";
      lhd = document1;
      patronImage = r3.bodyBytes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient2();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      MdiIcons.arrowLeft,
                      color: PrimaryDarkColor,
                      size: 30,
                    )),
              ),
              const SizedBox(width: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                clipBehavior: Clip.antiAlias,
                child: const Image(
                  width: 30,
                  height: 30,
                  image: AssetImage('assets/images/1.png'),
                ),
              ),
              const SizedBox(width: 8),
              CustomText(
                text: "LIBRARY",
                color: PrimaryDarkColor,
                textSize: 20,
              )
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Stack(
            children: [
              Column(
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
                        color: PrimaryDarkColor,
                      ),
                      padding: EdgeInsets.all(2),
                      child: Card(
                        color: PrimaryWhiteColor,
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
                                          child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Icon(
                                    MdiIcons.alertCircleOutline,
                                    color: PrimaryWhiteColor,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      height: 130,
                                      fit: BoxFit.fitHeight,
                                      image: Image.memory(patronImage).image,),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: PrimaryDarkColor.withAlpha(50),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: CustomText(
                                            text: category,
                                            textSize: 14,
                                            color: PrimaryDarkColor),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                          text: username,
                                          textSize: 22,
                                          color: PrimaryDarkColor),

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
                                              fontFamily:
                                              "ProductSans-Bold",),
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
                        color: PrimaryDarkColor,
                      ),
                      padding: EdgeInsets.all(2),
                      child: Card(
                        color: PrimaryWhiteColor,
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
                                    color: PrimaryDarkColor,
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: stream, textSize: 16, color: PrimaryDarkColor)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.emailOutline,
                                    color: PrimaryDarkColor,
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: email, textSize: 16, color: PrimaryDarkColor)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.phone,
                                    color: PrimaryDarkColor,
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: phone, textSize: 16, color: PrimaryDarkColor)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.humanMale,
                                    color: PrimaryDarkColor,
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: gender, textSize: 16, color: PrimaryDarkColor)
                                ],
                              ),
                              Divider(
                                height: 50,
                                color: PrimaryDarkColor,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.currencyRupee,
                                    color: PrimaryRedColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: fine, textSize: 30, color: PrimaryRedColor)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ),

                  // SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: HtmlWidget("<table style='width:100%'  border='1' cellpadding='15'>$lhd</table>")),

                  LibraryMenu(context),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      text: 'SCAN NEW BARCODE',
                      buttonSize: 60,
                      context: context,
                      function: () {
                        barcodeScan();
                      })),
            ],
          ),
        ),
      ),
    );
  }

  Widget LibraryMenu(BuildContext context) {
    LibraryMenuItems item1 = LibraryMenuItems(
        title: "SEARCH",
        img: Icon(
          MdiIcons.bookSearchOutline,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: HomePage());

    LibraryMenuItems item2 = LibraryMenuItems(
        title: "FINES",
        img: Icon(
          MdiIcons.currencyRupee,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryFinesView(booksFinesList: fines,));

    LibraryMenuItems item3 = LibraryMenuItems(
        title: "BOOKS",
        img: Icon(
          MdiIcons.bookshelf,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryIssuedBooksView(issuedBooksList: loans,));

    LibraryMenuItems item4 = LibraryMenuItems(
        title: "HISTORY",
        img: Icon(
          MdiIcons.history,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: LibraryHistoryView(libraryHistoryData: lhd,));

    LibraryMenuItems item5 = LibraryMenuItems(
        title: "BARCODE",
        img: Icon(
          MdiIcons.barcode,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: MapScreenView());

    LibraryMenuItems item6 = LibraryMenuItems(
        title: "ABOUT",
        img: Icon(
          MdiIcons.informationVariant,
          color: PrimaryWhiteColor,
          size: 25,
        ),
        Activity: MapScreenView());

    List<LibraryMenuItems> LibraryMenuItemsList = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
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
                        color: PrimaryDarkColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          data.img,

                          //SizedBox(height: 12.0,),
                          CustomText(
                              text: data.title,
                              textSize: 14,
                              color: PrimaryWhiteColor)
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
