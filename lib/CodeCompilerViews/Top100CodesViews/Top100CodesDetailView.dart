import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/sunburst.dart';
import '../../Components/common_component_widgets.dart';
import 'package:highlight/languages/cpp.dart';
import '../../colors/colors.dart';

class Top100CodesDetailView extends StatefulWidget {
  final String title, codeContent, timeComplexity;

  const Top100CodesDetailView(
      {Key? key,
      required this.codeContent,
      required this.timeComplexity,
      required this.title})
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
            child: appBarCommon(context, "TOP 100 CODES")),
        body: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.tag_rounded,
                    color: primaryDarkColor.withOpacity(0.5),
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.codeContent));
                      showSnackBar(context, "Code Copied Successfully.",
                          primaryGreenColor);
                    },
                    child: Icon(Icons.copy_rounded, color: primaryDarkColor),
                  ),
                  title: customTextBold(
                      text: widget.title,
                      textSize: 18,
                      color: primaryDarkColor),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      border: Border.all(color: primaryDarkColor, width: 1)),
                  child: CodeTheme(
                    data: CodeThemeData(styles: sunburstTheme),
                    child: SingleChildScrollView(
                      child: CodeField(
                        controller: controller,
                        textStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: primaryDarkColor.withOpacity(1),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextBold(
                            text: "Complexities",
                            textSize: 18,
                            color: primaryWhiteColor),
                        Divider(
                          color: primaryWhiteColor,
                          height: 25,
                        ),
                        customTextRegular(
                            text: widget.timeComplexity,
                            textSize: 14,
                            color: primaryGreenColor),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
