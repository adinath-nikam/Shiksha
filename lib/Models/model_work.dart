import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../AdControllers/ad_manager.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../WorkViews/edit_work_view.dart';
import '../colors/colors.dart';

//ignore: must_be_immutable
class ModelWork extends StatefulWidget {
  String? id;
  String? workTitle;
  String? workCompanyName;
  String? workCompensation;
  String? workLocation;
  String? workDescription;
  String? workPostURL;
  String? workType;
  String? workImageURL;
  String? workPostedDate;
  DocumentReference? reference;

  ModelWork({super.key});

  ModelWork.fromData(
      this.id,
      this.workTitle,
      this.workCompanyName,
      this.workCompensation,
      this.workDescription,
      this.workLocation,
      this.workType,
      this.workPostURL,
      this.workImageURL,
      this.workPostedDate,
      {super.key});

  ModelWork.fromMap(Map<String, dynamic> map,
      {super.key, required this.reference})
      :
        // assert(map['id'] != null),
        assert(map['workTitle'] != null),
        assert(map['workCompanyName'] != null),
        assert(map['workCompensation'] != null),
        assert(map['workDescription'] != null),
        assert(map['workLocation'] != null),
        assert(map['workType'] != null),
        assert(map['workPostURL'] != null),
        assert(map['workImageURL'] != null),
        assert(map['workPostedDate'] != null),
        id = reference?.id,
        workTitle = map['workTitle'],
        workCompanyName = map['workCompanyName'],
        workCompensation = map['workCompensation'],
        workDescription = map['workDescription'],
        workLocation = map['workLocation'],
        workType = map['workType'],
        workPostURL = map['workPostURL'],
        workImageURL = map['workImageURL'],
        workPostedDate = map['workPostedDate'];

  Map<String, dynamic> toMap() {
    return {
      "workTitle": workTitle,
      "workCompanyName": workCompanyName,
      "workCompensation": workCompensation,
      "workDescription": workDescription,
      "workLocation": workLocation,
      "workType": workType,
      "workPostURL": workPostURL,
      "workImageURL": workImageURL,
      "workPostedDate": workPostedDate,
    };
  }

  ModelWork.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );

  @override
  State<ModelWork> createState() => _ModelWorkState();
}

class _ModelWorkState extends State<ModelWork> implements BannerAdListener {
  late BannerAd adBannerWorkView;
  bool isWorkBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    AdManager.loadBannerAd(this).then((ad) => setState(() {
      adBannerWorkView = ad;
      isWorkBannerAdLoaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "WORK")),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isWorkBannerAdLoaded
                  ? Center(
                      child: SizedBox(
                        height: adBannerWorkView.size.height.toDouble(),
                        width: adBannerWorkView.size.width.toDouble(),
                        child: AdWidget(ad: adBannerWorkView),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.workImageURL!,
                      fit: BoxFit.fill,
                      height: 55,
                      width: 55,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return progressIndicator();
                      },
                    ),
                  ),


                  modelUserData.getUserIsAdmin ?

                  IconButton(
                      onPressed: () {
                        ModelWork e = ModelWork.fromData(
                          widget.id,
                          widget.workTitle,
                          widget.workCompanyName,
                          widget.workCompensation,
                          widget.workDescription,
                          widget.workLocation,
                          widget.workType,
                          widget.workPostURL,
                          widget.workImageURL,
                          widget.workPostedDate,
                        );
                        Navigator.of(context)
                            .push(animatedRoute(EditWorkView(modelWork: e)));
                      },
                      icon: Icon(
                        Icons.settings_rounded,
                        color: primaryDarkColor,
                        size: 30,
                      )) : SizedBox(),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              customTextBold(
                  text: widget.workTitle!,
                  textSize: 24,
                  color: primaryDarkColor),
              const SizedBox(
                height: 10,
              ),
              customTextBold(
                  text: widget.workCompanyName!,
                  textSize: 20,
                  color: primaryDarkColor.withAlpha(80)),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customTextBold(
                    text: widget.workType!,
                    textSize: 12,
                    color: primaryDarkColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      color: primaryDarkColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    customTextBold(
                        text: "${widget.workCompensation!} LPA",
                        textSize: 12,
                        color: primaryDarkColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: primaryDarkColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    customTextBold(
                        text: widget.workLocation!,
                        textSize: 12,
                        color: primaryDarkColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customTextRegular(
                  text: widget.workDescription!,
                  textSize: 14,
                  color: primaryDarkColor),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "APPLY",
                  buttonSize: 55,
                  context: context,
                  function: () {
                    try {
                      launch(widget.workPostURL!);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              if (modelUserData.getUserIsAdmin)
                CustomDeleteButton(
                    text: "DELETE",
                    buttonHeight: 60,
                    context: context,
                    function: () {
                      FirebaseFirestore.instance
                          .collection(DB_ROOT_NAME)
                          .doc(WORK_CONSTANTS)
                          .collection(WORK_CONSTANTS_OFFCAMPUS)
                          .doc(widget.id)
                          .delete()
                          .whenComplete(() {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => WillPopScope(
                            onWillPop: () async => false,
                            child: commonAlertDialog(
                                context,
                                "Delete Job Success!",
                                Icon(
                                  Icons.work_rounded,
                                  color: primaryDarkColor,
                                  size: 50,
                                ), () {
                              Navigator.of(context).pop();
                            }, 1),
                          ),
                        );
                      });
                    })
            ],
          ),
        ),
      ),
    ));
  }

  @override
  // TODO: implement onAdClicked
  AdEventCallback? get onAdClicked => throw UnimplementedError();

  @override
  // TODO: implement onAdClosed
  AdEventCallback? get onAdClosed => throw UnimplementedError();

  @override
  // TODO: implement onAdFailedToLoad
  AdLoadErrorCallback? get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdImpression
  AdEventCallback? get onAdImpression => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  AdEventCallback? get onAdLoaded => throw UnimplementedError();

  @override
  // TODO: implement onAdOpened
  AdEventCallback? get onAdOpened => throw UnimplementedError();

  @override
  // TODO: implement onAdWillDismissScreen
  AdEventCallback? get onAdWillDismissScreen => throw UnimplementedError();

  @override
  // TODO: implement onPaidEvent
  OnPaidEventCallback? get onPaidEvent => throw UnimplementedError();
}
