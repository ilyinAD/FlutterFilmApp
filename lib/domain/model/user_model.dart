import 'package:flutter_html/flutter_html.dart';

class UserModel {
  final String username;
  final String email;
  final int id;
  UserModel({required this.username, required this.email, required this.id});
  // Map<String, dynamic> toJson() {
  //   return {"id": id, "username": username, "email": email};
  // }
  //
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //       username: json["username"], email: json["email"], id: json["id"]);
  // }
}
