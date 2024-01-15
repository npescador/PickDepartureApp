// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/domain/users_repository.dart';

class UserRemoteImpl extends UsersRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserByBarcode(String barcode) async {
    UserModel? user;
    await _firestore
        .collection("users")
        .where("barcode", isEqualTo: barcode)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userFireBase = querySnapshot.docs.first;
        user = UserModel.fromMap(userFireBase.data());
      }
    });

    return user;
  }

  @override
  Future<UserModel?> getUserByEmailPassword(
      String email, String password) async {
    UserModel? user;
    await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userFireBase = querySnapshot.docs.first;
        user = UserModel.fromMap(userFireBase.data());
      }
    });

    return user;
  }

  @override
  Future<List<UserModel>> getUsers() async {
    List<UserModel> users = [];
    await _firestore.collection("users").get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          users.add(UserModel.fromMap(element.data()));
        }
      }
    });
    return users;
  }
}
