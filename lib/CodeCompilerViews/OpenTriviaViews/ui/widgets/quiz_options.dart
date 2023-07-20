import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_category.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_question.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/ui/views/open_trivia_error_view.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/ui/views/open_trivia_question_view.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/colors/colors.dart';

import '../../../../Components/AuthButtons.dart';
import '../../Api/api_provider.dart';

class TriviaOptionsDialog  extends StatefulWidget {
  final Category? category;

  const TriviaOptionsDialog({Key? key, this.category}) : super(key: key);

  @override
  _TriviaOptionsDialogState createState() => _TriviaOptionsDialogState();
}

class _TriviaOptionsDialogState extends State<TriviaOptionsDialog> {
  int? _noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: primaryDarkColor.withOpacity(0.1),
            child: customTextBold(
                text: widget.category!.name,
                textSize: 22,
                color: primaryDarkColor),
          ),
          SizedBox(height: 20.0),
          customTextRegular(
              text: "Select Total Number of Questions",
              textSize: 14,
              color: primaryDarkColor),
          SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: customTextRegular(
                      text: "10", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _noOfQuestions == 10
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "20", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _noOfQuestions == 20
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "30", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _noOfQuestions == 30
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "40", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _noOfQuestions == 40
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "50", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _noOfQuestions == 50
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          customTextRegular(
              text: "Select Difficulty Level",
              textSize: 14,
              color: primaryDarkColor),
          SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: customTextRegular(
                      text: "Any", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _difficulty == null
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectDifficulty(null),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "Easy", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _difficulty == "easy"
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "Medium", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _difficulty == "medium"
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: customTextRegular(
                      text: "Hard", textSize: 16, color: primaryWhiteColor),
                  backgroundColor: _difficulty == "hard"
                      ? primaryGreenColor
                      : primaryDarkColor.withOpacity(0.5),
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? Container(
                  padding: EdgeInsets.all(15), child: progressIndicator())
              : CustomButton(
                  text: "START",
                  buttonSize: 65,
                  context: context,
                  function: () {
                    _startQuiz();
                  }),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String? s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions =
          await getQuestions(widget.category!, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuizPage(
                    questions: questions,
                    category: widget.category,
                  )));
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}
