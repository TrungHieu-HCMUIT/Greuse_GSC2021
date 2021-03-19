import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String avatarURL;
  User({
    this.id,
    @required this.username,
    @required this.email,
    @required this.avatarURL,
  });

  Map<String, dynamic> toJson() {
    return {
      id: id,
      username: username,
      email: email,
      avatarURL: avatarURL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarURL: json['avatarURL'],
    );
  }
}
