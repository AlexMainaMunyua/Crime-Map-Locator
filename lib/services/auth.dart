import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Firebase user one time fetch
  User? get getUser => _auth.currentUser;

  //Firebase user a realtime Stream
  Stream<User?> get user => _auth.authStateChanges();

  //Sign in with google
  Future<User?> googleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential? credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential result = await _auth.signInWithCredential(credential!);
      User? user = result.user;

      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null!;
    }
  }

  //update the User's data in Firestore on each new login
  Future<void> updateUserData(User? user) {
    DocumentReference userRef = _db.collection('user').doc(user!.uid);
    return userRef.set({'userName': user.displayName, 'userEmail': user.email});
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
