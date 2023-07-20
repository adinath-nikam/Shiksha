import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Components/constants.dart';
import '../Models/model_user_data.dart';

class FirebaseAPI {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Stream<QuerySnapshot> eventsStream() {
    return firebaseFirestore
        .collection(DB_ROOT_NAME)
        .doc(EVENTS_CONSTANT)
        .collection(modelUserData.getUserCollege)
        .snapshots();
  }

  Stream<QuerySnapshot> workStream() {
    return firebaseFirestore
        .collection(DB_ROOT_NAME)
        .doc(WORK_CONSTANTS)
        .collection(WORK_CONSTANTS_OFFCAMPUS)
    .orderBy('workPostedDate',descending: true)
        .snapshots();
  }

  Stream<DatabaseEvent> realtimeDBStream(String reference) {
    return firebaseDatabase
        .ref(reference)
        .onValue;
  }

}
