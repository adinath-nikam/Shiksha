import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';

class LibraryHistoryView extends StatefulWidget {
  final String libraryHistoryData;

  const LibraryHistoryView({Key? key, required this.libraryHistoryData})
      : super(key: key);

  @override
  State<LibraryHistoryView> createState() => _LibraryHistoryViewState();
}

class _LibraryHistoryViewState extends State<LibraryHistoryView> {
  late String table;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    table = widget.libraryHistoryData;
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
                  padding: const EdgeInsets.only(left: 10),
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
              text: "FINES",
              color: PrimaryDarkColor,
              textSize: 20,
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
                child: HtmlWidget(
                    "<table border='1' cellpadding='15'>$table</table>"))),
      ),
    ));
  }
}
