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

  //creating the classroom
  createClassRoom(String classCode, Map classroomInfoMap) async {
    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .set(classroomInfoMap);
  }

//enrolling in new classrrom
  add(String userName, String classCode) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .get();
    if (!snapShot.exists) {
      return false;
    }
    List users = snapShot['users'];

    print(snapShot['users']);
    users.add(userName);
    FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .set({'users': users}, SetOptions(merge: true)).then((_) {
      print("success!");
    });
  }
}
