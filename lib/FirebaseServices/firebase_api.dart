import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_database/firebase_database.dart' as firebase_database;
import '../Components/constants.dart';
import '../Models/model_work.dart';

class FirebaseAPI {
  final firebase_firestore.FirebaseFirestore firebaseFirestore =
      firebase_firestore.FirebaseFirestore.instance;
  final firebase_database.FirebaseDatabase firebaseDatabase =
      firebase_database.FirebaseDatabase.instance;

  Stream<firebase_firestore.QuerySnapshot> workStream() {
    return firebaseFirestore
        .collection(DB_ROOT_NAME)
        .doc(WORK_CONSTANTS)
        .collection(WORK_CONSTANTS_OFFCAMPUS)
        .orderBy('workPostedDate', descending: true)
        .snapshots();
  }

  firebase_firestore.Query<ModelWork> queryWorkStream() {
    return firebaseFirestore
        .collection(DB_ROOT_NAME)
        .doc(WORK_CONSTANTS)
        .collection(WORK_CONSTANTS_OFFCAMPUS)
        .withConverter(
          fromFirestore: (snapshot, _) => ModelWork.fromSnapshot(snapshot),
          toFirestore: (workData, _) => workData.toMap(),
        )
        .orderBy('workPostedDate', descending: true);
  }

  Stream<firebase_database.DatabaseEvent> realtimeDBStream(String reference) {
    return firebaseDatabase.ref(reference).onValue;
  }
}
