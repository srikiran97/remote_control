import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;

import '../db_constants.dart';
import '../models/custom_error.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fauth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Stream<fauth.User?> get user => firebaseAuth.userChanges();

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final fauth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = userCredential.user!;

      await userRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        'cleaningHours': 0,
        'noOfPoints': 2,
        'noOfBadges': 1,
      });
    } on fauth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fauth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
