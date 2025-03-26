import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signUp(String email, String name, String password);
  Future<UserModel> signIn(String email, String password);
  Future<Unit> resetPassword(String email);
  Future<Unit> signOut();
  Future<UserModel> getUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDatasourceImpl(
      {required this.firebaseAuth, required this.firestore});

  @override
  Future<UserModel> signUp(String email, String name, String password) async {
    try {
      UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': credential.user!.email,
          'name': name
        });
        return UserModel(uid: credential.user!.uid, email: email, name: name);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (err.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (err.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenreicAuthException();
      }
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(credential.user!.uid).get();
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }

      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (err.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenreicAuthException();
      }
    }
  }

  @override
  Future<Unit> signOut() async {
    await firebaseAuth.signOut();
    return Future.value(unit);
  }

  @override
  Future<Unit> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
    return Future.value(unit);
  }

  @override
  Future<UserModel> getUser() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
      final userModel = UserModel.fromJson(
        userDoc.data() as Map<String, dynamic>,
      );
      return Future.value(userModel);
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
