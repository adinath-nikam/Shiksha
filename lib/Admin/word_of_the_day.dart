import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class AddWOTDView extends StatefulWidget {
  const AddWOTDView({Key? key}) : super(key: key);

  @override
  State<AddWOTDView> createState() => _AddWOTDViewState();
}

class _AddWOTDViewState extends State<AddWOTDView> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController posController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> wotdUpdateFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "UPDATE WOTD")),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Card(
              elevation: 10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Form(
                  key: wotdUpdateFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: wordController,
                        decoration: InputDecoration(
                          hintText: "Enter Word...",
                          prefixIcon: Icon(
                            Icons.flag_rounded,
                            color: primaryDarkColor,
                          ),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: posController,
                        decoration: InputDecoration(
                          hintText: "Enter Word POS...",
                          prefixIcon: Icon(
                            Icons.sort_by_alpha_rounded,
                            color: primaryDarkColor,
                          ),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? '* Required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: descController,
                        decoration: InputDecoration(
                          hintText: "Enter Word Description...",
                          prefixIcon: Icon(
                            Icons.text_fields_rounded,
                            color: primaryDarkColor,
                          ),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? '* Required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                          text: "UPDATE\t\t\tWOTD",
                          buttonSize: 60,
                          context: context,
                          function: () {
                            if (wotdUpdateFormKey.currentState!.validate()) {
                              wotdUpdateFormKey.currentState!.save();
                              FirebaseDatabase.instance
                                  .ref("SHIKSHA_APP/EXTRAS/WOTD")
                                  .set({
                                "WORD": wordController.text.toString().trim(),
                                "POS": posController.text.toString().trim(),
                                "MEANING":
                                    descController.text.toString().trim(),
                              }).whenComplete(() {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      WillPopScope(
                                    onWillPop: () async => false,
                                    child: commonAlertDialog(
                                        context,
                                        "WOTD Update Success!.",
                                        Icon(
                                          Icons.done,
                                          color: primaryDarkColor,
                                          size: 50,
                                        ), () {
                                      Navigator.of(context).pop();
                                    }, 1),
                                  ),
                                );
                              });
                            }
                          }),
                    ],
                  ),
                ),
              ),
            )),
      ),
    ));
  }
}
