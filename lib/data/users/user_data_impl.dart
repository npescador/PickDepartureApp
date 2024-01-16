import 'package:pick_departure_app/data/users/remote/user_remote_impl.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/domain/users_repository.dart';

class UserDataImpl extends UsersRepository {
  final UserRemoteImpl _remoteImpl;

  UserDataImpl({required UserRemoteImpl remoteImpl}) : _remoteImpl = remoteImpl;

  @override
  Future<UserModel?> getUserByEmailPassword(String email, String password) {
    return _remoteImpl.getUserByEmailPassword(email, password);
  }

  @override
  Future<List<UserModel>> getUsers() {
    return _remoteImpl.getUsers();
  }

  @override
  Future<UserModel?> getOrtderByORderCode(String barcode) {
    return _remoteImpl.getOrtderByORderCode(barcode);
  }
}
