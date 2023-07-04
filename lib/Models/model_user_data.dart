import 'package:firebase_database/firebase_database.dart';
import '../FirebaseServices/firebase_service.dart';
import '../Models/utilty_shared_preferences.dart';

final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

class ModelUserData {
  late final String userUID;
  late final String userUSN;
  late final String userSemester;
  late final String userStream;
  late final String userCollege;
  late final String userJoiningDate;
  bool userCanPostEvent = false;
  bool userCanPostJob = false;
  bool userIsAdmin = false;

  ModelUserData(
      {required this.userUID,
      required this.userUSN,
      required this.userCollege,
      required this.userSemester,
      required this.userStream,
      required this.userJoiningDate});

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

  set setStudentUid(String userUID) {
    this.userUID = userUID;
  }

  set setStudentUSN(String userUSN) {
    this.userUSN = userUSN;
  }

  set setStudentCollege(String userCollege) {
    this.userCollege = userCollege;
  }

  set setStudentBranch(String userStream) {
    this.userStream = userStream;
  }

  set setStudentSemester(String userSemester) {
    this.userSemester = userSemester;
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
    userJoiningDate = json['userJoiningDate'] as String;
    userCanPostEvent = json['userCanPostEvent'] as bool;
    userCanPostJob = json['userCanPostJob'] as bool;
    userIsAdmin = json['userIsAdmin'] as bool;
  }
}

late ModelUserData modelUserData;

Stream<ModelUserData?> getUserData() {
  return FirebaseDatabase.instance
      .ref("SHIKSHA_APP/USERS_DATA/${firebaseAuthServices.firebaseUser!.uid}")
      .onValue
      .map((event) {
    return modelUserData = ModelUserData.fromJson(
        event.snapshot.value as Map<dynamic, dynamic>);
  });
}


late ModelUserData tempUserData;

Future<ModelUserData> tempUserData2() async {
  try {
    modelUserData = ModelUserData.fromJson(
        await UtilitySharedPreferences().read('SP_SHIKSHA_USER_DATA'));

    return modelUserData;
  } catch (e) {
      print(">>> $e");
    return modelUserData;
  }
}