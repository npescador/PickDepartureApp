import 'package:pick_departure_app/data/users/user_model.dart';

abstract class UsersRepository {
  Future<List<UserModel>> getUsers();
  Future<UserModel?> getUser(String email, String password);
}
