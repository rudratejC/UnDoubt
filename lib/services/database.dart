import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
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

  //load the enrolled classrooms
  Future<Stream<QuerySnapshot>> getClassRooms() async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("classrooms")
        .orderBy("ts", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  //getting doubts from claassrooms
  getDoubts(String classCode) async {
    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .collection("doubts")
        .orderBy("time", descending: true)
        .snapshots();
  }

  //getting doubts from claassrooms
  getAnswers({String classCode, String doubtId}) async {
    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .collection("doubts")
        .doc(doubtId)
        .collection("answers")
        .orderBy("time", descending: true)
        .snapshots();
  }

  //adding doubts to classroom
  Future addDoubt(String classCode, String doubt) async {
    String id = randomAlphaNumeric(6);
    String myUsername = await SharedPreferenceHelper().getUserName();
    Map<String, dynamic> map = {
      "askedBy": myUsername,
      "desc": doubt,
      "time": DateTime.now()
    };
    print(classCode);
    print(map);

    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .collection("doubts")
        .doc(id)
        .set(map);
  }

  //getting answers by doubt code
  Future addAns(
      String classCode, String doubtId, String ans, bool public) async {
    String id = randomAlphaNumeric(6);
    String myUsername = await SharedPreferenceHelper().getUserName();
    String myName = await SharedPreferenceHelper().getDisplayName();
    Map<String, dynamic> map = {
      "addedBy": myUsername,
      "desc": ans,
      "time": DateTime.now(),
      "public": public,
      "name": myName,
      "img": false,
      "imgUrl": "",
    };
    print(classCode);
    print(doubtId);
    print(map);

    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .collection("doubts")
        .doc(doubtId)
        .collection("answers")
        .doc(id)
        .set(map);
  }

  //delete classrooms
  delete(String userName, String classCode) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .get();
    if (!snapShot.exists) {
      return false;
    }
    List users = snapShot['users'];
    print(snapShot['users']);
    users.remove(userName);
    FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .set({'users': users}, SetOptions(merge: true)).then((_) {
      print("success!");
    });
  }

  //Add answer image
  addImageAns({File image, public, classCode, doubtId}) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('/${image.path}');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);
    String id = randomAlphaNumeric(6);
    String myUsername = await SharedPreferenceHelper().getUserName();
    String myName = await SharedPreferenceHelper().getDisplayName();
    Map<String, dynamic> map = {
      "addedBy": myUsername,
      "desc": "",
      "time": DateTime.now(),
      "public": true,
      "name": myName,
      "img": true,
      "imgUrl": imageUrl,
    };
    return FirebaseFirestore.instance
        .collection("classrooms")
        .doc(classCode)
        .collection("doubts")
        .doc(doubtId)
        .collection("answers")
        .doc(id)
        .set(map);
  }

  //get user info
  getUserInfo(String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  Future<bool> checkWord(element) async {
    Stream s = FirebaseFirestore.instance
        .collection("data")
        .where("words", arrayContains: element)
        .snapshots();
    if (s != null) {
      return false;
    } else {
      return true;
    }
  }
}
