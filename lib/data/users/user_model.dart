import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  int id;
  String name;
  String password;
  String barcode;
  String email;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.barcode,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        password: json["password"],
        barcode: json["barcode"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "password": password,
        "barcode": barcode,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}
