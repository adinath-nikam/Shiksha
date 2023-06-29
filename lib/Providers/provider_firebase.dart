import 'package:firebase_database/firebase_database.dart';

Stream getColleges(){
  return FirebaseDatabase.instance.ref("SHIKSHA_APP/COLLEGES").onValue;
}