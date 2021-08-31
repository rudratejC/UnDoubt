import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:undoubt/helpers/sharedpref_helper.dart';

class DatabaseMethods {
  //for adding user data to firestore on google sign in
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }
}
