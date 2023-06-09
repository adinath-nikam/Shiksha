import 'package:cloud_firestore/cloud_firestore.dart';

class ModelCampaign {
  String? id;
  String? campaignName;
  String? campaignImgURL;
  String? campaignURL;
  String? campaignTimeStamp;
  bool? isActive;

  DocumentReference? reference;

  ModelCampaign();

  ModelCampaign.fromData(
    this.campaignName,
    this.campaignImgURL,
    this.campaignURL,
    this.campaignTimeStamp,
    this.isActive,
  );

  ModelCampaign.fromMap(Map<String, dynamic> map, {required this.reference})
      :
        // assert(map['id'] != null),
        assert(map['campaignName'] != null),
        assert(map['campaignImgURL'] != null),
        assert(map['campaignURL'] != null),
        assert(map['campaignTimeStamp'] != null),
        assert(map['isActive'] != null),
        id = reference?.id,
        campaignName = map['campaignName'],
        campaignImgURL = map['campaignImgURL'],
        campaignURL = map['campaignURL'],
        campaignTimeStamp = map['campaignTimeStamp'],
        isActive = map['isActive'];

  Map<String, dynamic> toMap() {
    return {
      "campaignName": campaignName,
      "campaignImgURL": campaignImgURL,
      "campaignURL": campaignURL,
      "campaignTimeStamp": campaignTimeStamp,
      "isActive": isActive,
    };
  }

  ModelCampaign.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );
}
