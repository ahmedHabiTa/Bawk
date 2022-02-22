// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
   required this.username,
   required this.password,
   required this.email,
    this.imageAsBase64,
    this.intrestId,
    this.id,
  });

  final String username;
  final String  password;
  final String  email;
  final String?  imageAsBase64;
  final String?  intrestId;
  final String?  id;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    password: json["password"],
    email: json["email"],
    imageAsBase64: json["imageAsBase64"] == null ? null : json["imageAsBase64"],
    intrestId: json["intrestId"],
    id: json["id"],
  );
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    username: map["username"],
    password: map["password"],
    email: map["email"],
    imageAsBase64: map["imageAsBase64"] == null ? null : map["imageAsBase64"],
    intrestId: map["intrestId"],
    id: map["id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "email": email,
    "imageAsBase64": imageAsBase64 == null ? null : imageAsBase64,
    "intrestId": intrestId,
    "id": id,
  };
}
