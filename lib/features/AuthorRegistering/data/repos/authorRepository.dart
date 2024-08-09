import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookify/features/AuthorRegistering/data/models/authorModel.dart';

class AuthorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAuthorProfile(AuthorProfilePacket profilePacket) async {
    await _firestore.collection('authors').add(profilePacket.toMap());
  }
}
