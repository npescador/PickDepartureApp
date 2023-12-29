import 'package:pick_departure_app/data/users/local/user_local_impl.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/domain/users_repository.dart';

class UserDataImpl extends UsersRepository {
  final UserLocalImpl _localImpl;

  UserDataImpl({required UserLocalImpl localImpl}) : _localImpl = localImpl;

  @override
  Future<UserModel?> getUser(String email, String password) {
    return _localImpl.getUser(email, password);
  }

  @override
  Future<List<UserModel>> getUsers() {
    return _localImpl.getUsers();
  }
}
