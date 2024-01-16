import 'dart:async';

import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/domain/users_repository.dart';
import 'package:pick_departure_app/presentation/base/base_view_model.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';

class UserViewModel extends BaseViewModel {
  final UsersRepository _usersRepository;

  final StreamController<ResourceState<List<UserModel>>> getUsersState =
      StreamController();

  final StreamController<ResourceState<UserModel?>> getUsersEmailPasswordState =
      StreamController();

  final StreamController<ResourceState<UserModel?>> getUsersBarcodeState =
      StreamController();

  UserViewModel({required UsersRepository usersRepository})
      : _usersRepository = usersRepository;

  @override
  void dispose() {
    getUsersState.close();
  }

  fetchUsers() {
    getUsersState.add(ResourceState.loading());

    _usersRepository
        .getUsers()
        .then((value) => getUsersState.add(ResourceState.success(value)))
        .catchError((error) => getUsersState.add(ResourceState.error(error)));
  }

  fetchUserByBarcode(String barcode) async {
    getUsersBarcodeState.add(ResourceState.loading());

    _usersRepository
        .getOrtderByORderCode(barcode)
        .then((value) => getUsersBarcodeState.add(ResourceState.success(value)))
        .catchError(
            (error) => getUsersBarcodeState.add(ResourceState.error(error)));
  }

  fetchUserByEmailPassword(String email, String password) {
    getUsersEmailPasswordState.add(ResourceState.loading());

    _usersRepository
        .getUserByEmailPassword(email, password)
        .then((value) =>
            getUsersEmailPasswordState.add(ResourceState.success(value)))
        .catchError((error) =>
            getUsersEmailPasswordState.add(ResourceState.error(error)));

    //return await _usersRepository.getUserByEmailPassword(email, password);
  }
}
