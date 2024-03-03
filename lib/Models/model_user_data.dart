import 'package:shiksha/Components/constants.dart';
import '../Models/utilty_shared_preferences.dart';

class ModelUserData {
  late final String userUID;
  late final String userUSN;
  late final String userSemester;
  late final String userStream;
  late final String userCategory;
  late final String userCollege;
  late final String userEmail;
  late final String userPhone;
  late final String userJoiningDate;
  late final String userCollegeType;
  bool userCanPostEvent = true;
  bool userCanPostJob = true;
  bool userIsAdmin = true;

  ModelUserData(
      {required this.userUID,
      required this.userUSN,
      required this.userCollege,
      required this.userSemester,
      required this.userStream,
      required this.userCategory,
      required this.userJoiningDate,
      required this.userEmail,
      required this.userCollegeType,
      required this.userPhone});

  String get getUserUID {
    return userUID;
  }

  String get getUserUSN {
    return userUSN;
  }

  String get getUserCollege {
    return userCollege;
  }

  String get getUserSemester {
    return userSemester;
  }

  String get getUserStream {
    return userStream;
  }

  String get getUserCategory {
    return userCategory;
  }

  String get getUserCollegeType {
    return userCollegeType;
  }

  String get getUserEmail {
    return userEmail;
  }

  String get getUserPhone {
    return userPhone;
  }

  String get getUserJoiningDate {
    return userJoiningDate;
  }

  bool get getUserCanPostEvent {
    return userCanPostEvent;
  }

  bool get getUserCanPostJob {
    return userCanPostJob;
  }

  bool get getUserIsAdmin {
    return userIsAdmin;
  }

  set setUserUid(String userUID) {
    this.userUID = userUID;
  }

  set setUserUSN(String userUSN) {
    this.userUSN = userUSN;
  }

  set setCollegeCollege(String userCollege) {
    this.userCollege = userCollege;
  }

  set setUserCollegeType(String userCollegeType) {
    this.userCollegeType = userCollegeType;
  }

  set setUserBranch(String userStream) {
    this.userStream = userStream;
  }

  set setUserSemester(String userSemester) {
    this.userSemester = userSemester;
  }

  set setUserCategory(String userCategory) {
    this.userCategory = userCategory;
  }

  set setUserEmail(String userEmail) {
    this.userEmail = userEmail;
  }

  set setUserPhone(String userPhone) {
    this.userPhone = userPhone;
  }

  set setJoiningDate(String userJoiningDate) {
    this.userJoiningDate = userJoiningDate;
  }

  set setCanPostEvent(bool userCanPostEvent) {
    this.userCanPostEvent = userCanPostEvent;
  }

  set setCanPostJob(bool userCanPostJob) {
    this.userCanPostJob = userCanPostJob;
  }

  set setIsAdmin(bool userIsAdmin) {
    this.userIsAdmin = userIsAdmin;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'userUID': userUID,
        'userUSN': userUSN,
        'userCollege': userCollege,
        'userStream': userStream,
        'userSemester': userSemester,
        'userEmail': userEmail,
        'userPhone': userPhone,
        'userCategory': userCategory,
        'userCollegeType': userCollegeType,
        'userJoiningDate': userJoiningDate,
        'userCanPostEvent': userCanPostEvent,
        'userCanPostJob': userCanPostJob,
        'userIsAdmin': userIsAdmin,
      };

  ModelUserData.fromJson(Map<dynamic, dynamic> json) {
    userUID = json['userUID'] as String;
    userUSN = json['userUSN'] as String;
    userCollege = json['userCollege'] as String;
    userStream = json['userStream'] as String;
    userSemester = json['userSemester'] as String;
    userEmail = json['userEmail'] as String;
    userCategory = json['userCategory'] as String;
    userPhone = json['userPhone'] as String;
    userCollegeType = json['userCollegeType'] as String;
    userJoiningDate = json['userJoiningDate'] as String;
    userCanPostEvent = json['userCanPostEvent'] as bool;
    userCanPostJob = json['userCanPostJob'] as bool;
    userIsAdmin = json['userIsAdmin'] as bool;
  }
}

late ModelUserData modelUserData;

Future<ModelUserData> getUserData() async {
  try {
    modelUserData = ModelUserData.fromJson(
        await UtilitySharedPreferences().read(CONST_SP_USER_DATA));

    return modelUserData;
  } catch (e) {
    return modelUserData;
  }
}
