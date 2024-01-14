import 'package:pick_departure_app/data/users/local/user_local_impl.dart';
import 'package:pick_departure_app/data/users/remote/user_remote_impl.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/domain/users_repository.dart';

class UserDataImpl extends UsersRepository {
  final UserLocalImpl _localImpl;
  final UserRemoteImpl _remoteImpl;

  UserDataImpl(
      {required UserLocalImpl localImpl, required UserRemoteImpl remoteImpl})
      : _localImpl = localImpl,
        _remoteImpl = remoteImpl;

  @override
  Future<UserModel?> getUserByEmailPassword(String email, String password) {
    return _remoteImpl.getUserByEmailPassword(email, password);
  }

  @override
  Future<List<UserModel>> getUsers() {
    return _localImpl.getUsers();
  }

  @override
  Future<UserModel?> getUserByBarcode(String barcode) {
    return _localImpl.getUserByBarcode(barcode);
  }
}
