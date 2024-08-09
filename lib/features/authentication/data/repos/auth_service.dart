// repos/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookify/core/databaseService.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> saveLoginState(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final db = AuthDatabaseService();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', user.email ?? '');
    await prefs.setString('userFullName', user.displayName ?? '');
    await prefs.setString(
        'PhotoUrl', user.photoURL != null ? user.photoURL! : 'pl');

    // Save additional profile data in the database
    db.SetProfile({
      'email': user.email,
      'image': user.photoURL,
      'name': user.displayName,
      'phone': user.phoneNumber
    }, user.email ?? '');
  }
}
