import 'package:flutter/material.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/models/model_question.dart';
import 'package:shiksha/CodeCompilerViews/OpenTriviaViews/ui/views/check_answers.dart';
import 'package:shiksha/colors/colors.dart';

import '../../../../Components/AuthButtons.dart';
import '../../../../Components/common_component_widgets.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  QuizFinishedPage({Key? key, required this.questions, required this.answers})
      : super(key: key);

  @override
  _QuizFinishedPageState createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {
  int? correctAnswers;

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    this.widget.answers.forEach((index, value) {
      if (this.widget.questions[index].correctAnswer == value) correct++;
    });

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "RESULTS")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: primaryDarkColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(
                      Icons.question_mark_rounded,
                      color: primaryDarkColor,
                    ),
                    title: customTextBold(
                        text: "Total Questions",
                        textSize: 18,
                        color: primaryDarkColor),
                    trailing: customTextBold(
                        text: "${widget.questions.length}",
                        textSize: 18,
                        color: primaryDarkColor)
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: primaryDarkColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(
                      Icons.score_rounded,
                      color: primaryDarkColor,
                    ),
                    title: customTextBold(
                        text: "Score",
                        textSize: 18,
                        color: primaryDarkColor),
                    trailing: customTextBold(
                        text: "${correct / widget.questions.length * 100}%",
                        textSize: 18,
                        color: primaryDarkColor)
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: primaryDarkColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(
                      Icons.done_rounded,
                      color: primaryDarkColor,
                    ),
                    title: customTextBold(
                        text: "Correct Answers",
                        textSize: 18,
                        color: primaryDarkColor),
                    trailing: customTextBold(
                        text: "$correct/${widget.questions.length}",
                        textSize: 18,
                        color: primaryDarkColor)
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: primaryDarkColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: const Icon(
                    Icons.cancel_rounded,
                    color: primaryDarkColor,
                  ),
                  title: customTextBold(
                      text: "Incorrect Answers",
                      textSize: 18,
                      color: primaryDarkColor),
                  trailing: customTextBold(
                      text: "${widget.questions.length - correct}/${widget.questions.length}",
                      textSize: 18,
                      color: primaryDarkColor)
                ),
              ),
              SizedBox(height: 20.0),

              CustomButton(text: 'HOME', buttonSize: 70, context: context, function: (){Navigator.pop(context);}),
              SizedBox(height: 20,),
              CustomButton(text: 'CHECK ANSWERS', buttonSize: 70, context: context, function: (){

                Navigator.of(context).push(

                  animatedRoute(CheckAnswersPage(
                    questions: widget.questions,
                    answers: widget.answers,
                  )));


              }),

            ],
          ),
        ),
      ),
    );
  }
}
