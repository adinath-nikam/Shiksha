import 'package:flutter/material.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_category.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_question.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/ui/views/open_trivia_result_view.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'dart:async';

import '../../../../Components/common_component_widgets.dart';
import '../../../../colors/colors.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category? category;

  const QuizPage({Key? key, required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers!;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, widget.category!.name)),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: primaryDarkColor,
                      child: customTextBold(
                          text: "Q.${_currentIndex + 1}",
                          textSize: 16,
                          color: primaryWhiteColor)),
                  SizedBox(width: 20.0),
                  Expanded(
                      child: customTextBold(
                          text: HtmlUnescape().convert(
                              widget.questions[_currentIndex].question!),
                          textSize: 22,
                          color: primaryDarkColor)),
                ],
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ...options.map((option) => RadioListTile(
                            title: customTextBold(
                                text: HtmlUnescape().convert("$option"),
                                textSize: 18,
                                color: primaryDarkColor),
                            groupValue: _answers[_currentIndex],
                            value: option,
                            onChanged: (dynamic value) {
                              setState(() {
                                _answers[_currentIndex] = option;
                              });
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: CustomButton(
            text: _currentIndex == (widget.questions.length - 1)
                ? "Submit"
                : "Next",
            buttonSize: 70,
            context: context,
            function: () {
              _nextSubmit();
            }),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      showSnackBar(
          context, "You must select an answer to continue.", primaryRedColor);

      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: customTextBold(
                text:
                    "Are you sure you want to quit the quiz? All your progress will be lost.",
                textSize: 16,
                color: primaryDarkColor),
            title: customTextBold(
                text: "Warning!", textSize: 16, color: primaryRedColor),
            actions: <Widget>[
              TextButton(
                child: customTextBold(
                    text: "Yes", textSize: 14, color: primaryRedColor),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: customTextBold(
                    text: "No", textSize: 14, color: primaryDarkColor),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }
}
