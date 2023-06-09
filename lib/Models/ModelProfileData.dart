import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/AuthViews/ProfileBuildStepperView.dart';
import 'package:shiksha/FirebaseServices/FirebaseService.dart';
import 'package:shiksha/HomeView/HomeView.dart';

import '../HomeView/TabView.dart';

final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

class ModelProfileData {
  late final String StudentUid;
  late final String StudentUSN;
  late final String StudentEmail;
  late final String StudentUsername;
  late final String StudentPhone;
  late final String StudentSemester;
  late final String StudentBranch;
  late final String StudentCollege;
  late final String StudentGender;
  late final String StudentDOB;
  late final String JoiningDate;
  bool CanPostEvent = false;
  bool CanPostJob = false;
  bool IsAdmin = false;

  ModelProfileData(
      {required this.StudentUid,
      required this.StudentBranch,
      required this.StudentCollege,
      required this.StudentDOB,
      required this.StudentEmail,
      required this.StudentGender,
      required this.StudentPhone,
      required this.StudentSemester,
      required this.StudentUsername,
      required this.StudentUSN,
      required this.JoiningDate
      });

  String get getStudentUid {
    return StudentUid;
  }

  String get getStudentBranch {
    return StudentBranch;
  }

  String get getStudentCollege {
    return StudentCollege;
  }

  String get getStudentDOB {
    return StudentDOB;
  }

  String get getStudentEmail {
    return StudentEmail;
  }

  String get getStudentGender {
    return StudentGender;
  }

  String get getStudentPhone {
    return StudentPhone;
  }

  String get getStudentSemester {
    return StudentSemester;
  }

  String get getStudentUsername {
    return StudentUsername;
  }

  String get getStudentUSN {
    return StudentUSN;
  }


  String get getJoiningDate {
    return JoiningDate;
  }

  bool get getCanPostEvent {
    return CanPostEvent;
  }

  bool get getCanPostJob {
    return CanPostJob;
  }

  bool get getIsAdmin {
    return IsAdmin;
  }

  set setStudentUid(String StudentUid) {
    this.StudentUid = StudentUid;
  }

  set setStudentUsername(String StudentUsername) {
    this.StudentUsername = StudentUsername;
  }

  set setStudentUSN(String StudentUSN) {
    this.StudentUSN = StudentUSN;
  }

  set setStudentPhone(String StudentPhone) {
    this.StudentPhone = StudentPhone;
  }

  set setStudentCollege(String StudentCollege) {
    this.StudentCollege = StudentCollege;
  }

  set setStudentBranch(String StudentBranch) {
    this.StudentBranch = StudentBranch;
  }

  set setStudentSemester(String StudentSemester) {
    this.StudentSemester = StudentSemester;
  }

  set setStudentDOB(String StudentDOB) {
    this.StudentDOB = StudentDOB;
  }

  set setStudentEmail(String StudentEmail) {
    this.StudentEmail = StudentEmail;
  }

  set setStudentGender(String StudentGender) {
    this.StudentGender = StudentGender;
  }

  set setJoiningDate(String JoiningDate) {
    this.JoiningDate = JoiningDate;
  }

  set setCanPostEvent(bool CanPostEvent) {
    this.CanPostEvent = CanPostEvent;
  }

  set setCanPostJob(bool CanPostJob) {
    this.CanPostJob = CanPostJob;
  }

  set setIsAdmin(bool IsAdmin) {
    this.IsAdmin = IsAdmin;
  }



  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'StudentUID': StudentUid,
        'StudentUSN': StudentUSN,
        'StudentEmail': StudentEmail,
        'StudentUsername': StudentUsername,
        'StudentPhone': StudentPhone,
        'StudentGender': StudentGender,
        'StudentCollege': StudentCollege,
        'StudentBranch': StudentBranch,
        'StudentSemester': StudentSemester,
        'StudentDOB': StudentDOB,
        'JoiningDate': JoiningDate,
    'CanPostEvent' : CanPostEvent,
    'CanPostJob' : CanPostJob,
    'IsAdmin' : IsAdmin,
      };

  ModelProfileData.fromJson(Map<dynamic, dynamic> json) {
    StudentUid = json['StudentUID'] as String;
    StudentUSN = json['StudentUSN'] as String;
    StudentEmail = json['StudentEmail'] as String;
    StudentUsername = json['StudentUsername'] as String;
    StudentPhone = json['StudentPhone'] as String;
    StudentGender = json['StudentGender'] as String;
    StudentCollege = json['StudentCollege'] as String;
    StudentBranch = json['StudentBranch'] as String;
    StudentSemester = json['StudentSemester'] as String;
    StudentDOB = json['StudentDOB'] as String;
    JoiningDate = json['JoiningDate'] as String;
    CanPostEvent = json['CanPostEvent'] as bool;
    CanPostJob = json['CanPostJob'] as bool;
    IsAdmin = json['IsAdmin'] as bool;
  }
}


// Retrieve User Data from Firebase RTDB and Stream
late ModelProfileData modelProfileData;

Stream<ModelProfileData?> getUserInfo() {
  return FirebaseDatabase.instance.ref("SHIKSHA_APP/USERS_DATA/${firebaseAuthServices.firebaseUser!.uid}")
      .onValue.map((event) {
    return modelProfileData = ModelProfileData.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
  });
}