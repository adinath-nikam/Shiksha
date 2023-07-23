import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:flutter_highlight/themes/sunburst.dart';

import '../../Components/common_component_widgets.dart';

import 'package:html/parser.dart' show parse;
import 'package:highlight/languages/cpp.dart';

import '../../colors/colors.dart';

class Top100CodesDetailView extends StatefulWidget {
  final String codeContent;

  const Top100CodesDetailView({Key? key, required this.codeContent})
      : super(key: key);

  @override
  State<Top100CodesDetailView> createState() => _Top100CodesDetailViewState();
}

class _Top100CodesDetailViewState extends State<Top100CodesDetailView> {
  late final controller;
  late String code;

  @override
  void initState() {
    super.initState();
    code = widget.codeContent.replaceAll("<p>", "\n");
    code = code.replaceAll("</p>", "\n");
    code = code.replaceAll("&lt;", "<");
    code = code.replaceAll("&gt;", ">");
    code = code.replaceAll("&nbsp;", "\t");
    controller = CodeController(text: code, language: cpp);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "Top 100 Codes")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                title: customTextBold(
                    text: "Prime Number",
                    textSize: 18,
                    color: primaryDarkColor),
                subtitle: customTextRegular(
                    text: "Prime Number",
                    textSize: 14,
                    color: primaryDarkColor),
              ),
              
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: primaryDarkColor, width: 1)),
                child: CodeTheme(
                  data: CodeThemeData(styles: sunburstTheme),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: controller,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
