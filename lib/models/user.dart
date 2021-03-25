import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String displayname;
  final String email;
  final String avatarURL;
  User({
    this.id,
    @required this.displayname,
    @required this.email,
    @required this.avatarURL,
  });

  Map<String, dynamic> toJson() {
    return {
      id: id,
      displayname: displayname,
      email: email,
      avatarURL: avatarURL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      displayname: json['displayname'],
      email: json['email'],
      avatarURL: json['photoUrl'],
    );
  }
}
