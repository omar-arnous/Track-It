import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signUp(String email, String name, String password);
  Future<UserModel> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDatasourceImpl(
      {required this.firebaseAuth, required this.firestore});

  @override
  Future<UserModel> signUp(String email, String name, String password) async {
    UserCredential credential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': credential.user!.email,
      'name': name
    });

    return UserModel(uid: credential.user!.uid, email: email, name: name);
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch user data from Firestore
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(credential.user!.uid).get();
    return UserModel.fromFirebase(userDoc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
