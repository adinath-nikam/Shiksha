import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_question.dart';
import 'package:shiksha/Components/AuthButtons.dart';

import '../../../../Components/common_component_widgets.dart';
import '../../../../colors/colors.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage(
      {Key? key, required this.questions, required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "ANSWERS")),
      body: ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16.0),
        itemCount: questions.length + 1,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomButton(
            text: "DONE",
            buttonSize: 70,
            context: context,
            function: () {
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
            }),
      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: primaryDarkColor, width: 1.0),
            borderRadius: BorderRadius.circular(4.0)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customTextBold(
                  text: HtmlUnescape().convert(question.question!),
                  textSize: 18,
                  color: primaryDarkColor),
              SizedBox(height: 15.0),
              customTextBold(
                  text: HtmlUnescape().convert("${answers[index]}"),
                  textSize: 16,
                  color: correct ? primaryGreenColor : primaryRedColor),
              SizedBox(height: 15.0),
              correct
                  ? Container()
                  : customTextBold(
                      text:
                          "Answer: \t ${HtmlUnescape().convert(question.correctAnswer!)}",
                      textSize: 16,
                      color: primaryGreenColor),
            ],
          ),
        ),
      ),
    );
  }
}
