import 'package:pick_departure_app/data/users/user_model.dart';

abstract class UsersRepository {
  Future<List<UserModel>> getUsers();
  Future<UserModel?> getUserByEmailPassword(String email, String password);
  Future<UserModel?> getUserByBarcode(String barcode);
}
