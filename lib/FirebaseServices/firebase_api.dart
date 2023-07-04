import 'package:cloud_firestore/cloud_firestore.dart';
import '../Components/constants.dart';
import '../Models/model_user_data.dart';

class FirebaseFirestoreEventsApi {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
        .snapshots();
  }
}
