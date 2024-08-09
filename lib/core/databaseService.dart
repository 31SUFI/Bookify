import 'dart:developer'; // Import this for the log function
import 'package:bookify/features/AuthorRegistering/data/models/authorModel.dart';
import 'package:bookify/features/AuthorRegistering/presentation/registerAuthor.dart';
import 'package:bookify/features/BookUploading/presentation/BookDetailUploading.dart';
import 'package:bookify/features/authentication/presentation/ProfileSection.dart';
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

class AuthDatabaseService {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  void updateProfile(ProfilePacket packet) {
    try {
      _fire.collection("ProfileDetails").add(packet.toMap());
    } catch (e) {
      print(e.toString()); // Log the error message
    }
    print('Profile updated with details: ${packet.toMap()}');
  }

  void SetProfile(Map<String, dynamic> packet, String docNAME) {
    try {
      _fire.collection("ProfileDetails").doc(docNAME).set(packet);
    } catch (e) {
      print(e.toString()); // Log the error message
    }
    print('Profile updated with details: ${packet}');
  }
}

class DatabaseService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createAuthorProfile(AuthorProfilePacket packet) {
    try {
      _firestore.collection("AuthorDetails").add(packet.toMap());
      log('Profile updated with details: ${packet.toMap()}');
    } catch (e) {
      log(e.toString()); // Log the error message
    }
  }
}
