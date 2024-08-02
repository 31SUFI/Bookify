import 'dart:developer'; // Import this for the log function
import 'package:bookify/BookUploading/BookDetailUploading.dart';
import 'package:bookify/authentication/ProfileSection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:login_page/testingFirestore.dart';

class Databaseservice {
  final _fire = FirebaseFirestore.instance;

  void create(Packet pack) {
    try {
      _fire.collection("BookDetails").add(pack.toMap());
    } catch (e) {
      log(e.toString()); // Log the error message
    }
  }

  // update() async {
  //   try {
  //     await _fire
  //         .collection("Lora")
  //         .doc("K6Swy1xsenAqdvEnrBIw")
  //         .update({"name": "Asima", "email": "123.com"});
  //   } catch (e) {
  //     log(e.toString()); // Log the error message
  //   }
  // }

  // delete() async {
  //   try {
  //     _fire.collection("aaa").doc("K6Swy1xsenAqdvEnrBIw").delete();
  //   } catch (e) {
  //     log(e.toString()); // Log the error message
  //   }
  // }
}

class DatabaseService {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  void updateProfile(ProfilePacket packet) {
    try {
      _fire.collection("ProfileDetails").add(packet.toMap());
    } catch (e) {
      print(e.toString()); // Log the error message
    }
    print('Profile updated with details: ${packet.toMap()}');
  }
}
