import 'package:flutter/material.dart';
import 'package:shiksha/Components/AuthButtons.dart';

/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatelessWidget {
  /// List to display the answer.
  final List<String> answers;

  /// Widget to display the question.
  final Widget question;

  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.

  MultiSelectDialog({required this.answers, required this.question});

  @override
  Widget build(BuildContext context) {
    Map<String, bool> mappedItem = Map.fromIterable(answers,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });

    return SimpleDialog(
      title: question,
      children: [
        ...mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key),
                // Displays the option
                value: mappedItem[key],
                // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem[key] = value!)),
          );
        }).toList(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 10),
            alignment: Alignment.center,
            child: CustomButton(
                text: "Done",
                buttonSize: 50,
                context: context,
                function: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}
