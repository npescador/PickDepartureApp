import 'package:flutter/foundation.dart';
import 'package:pick_departure_app/data/local/local_database_helper.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserLocalImpl {
  final LocalDataBaseHelper _dbHelper = LocalDataBaseHelper();

  Future<List<UserModel>> getUsers() async {
    Database db = await _dbHelper.getDb();

    final dataBaseUsers = await db.query(LocalDataBaseHelper.userTable);
    final userList = dataBaseUsers.map((e) => UserModel.fromMap(e));

    await _dbHelper.closeDb();

    return userList.isNotEmpty ? userList.toList() : [];
  }

  Future<UserModel?> getUser(String email, String password) async {
    try {
      Database db = await _dbHelper.getDb();

      final dataBaseUser = await db.rawQuery(
          'SELECT * FROM ${LocalDataBaseHelper.userTable} WHERE email = ? AND password = ?',
          [email, password]);

      UserModel? user;
      if (dataBaseUser.isNotEmpty) {
        user = UserModel.fromMap(dataBaseUser.first);
      }

      return user;
    } catch (e) {
      debugPrint('Error al obtener usuario: $e');
      return null;
    } finally {
      await _dbHelper.closeDb();
    }
  }

  Future<UserModel?> getUserByBarcode(String barcode) async {
    try {
      Database db = await _dbHelper.getDb();

      final dataBaseUser = await db.rawQuery(
          'SELECT * FROM ${LocalDataBaseHelper.userTable} WHERE barcode = ?',
          [barcode]);

      UserModel? user;
      if (dataBaseUser.isNotEmpty) {
        user = UserModel.fromMap(dataBaseUser.first);
      }

      return user;
    } catch (e) {
      debugPrint('Error al obtener usuario: $e');
      return null;
    } finally {
      await _dbHelper.closeDb();
    }
  }
}
