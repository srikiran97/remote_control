import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remote_control/models/custom_error.dart';

import '../db_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;
  UserRepository({
    required this.firebaseFirestore,
  });

  Future<UserModel> getUserDetails({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await userRef.doc(uid).get();

      if (userDoc.exists) {
        final currentUser = UserModel.fromDoc(userDoc);
        return currentUser;
      }

      throw 'User does not exist';
    } on FirebaseException catch (e) {
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
}
