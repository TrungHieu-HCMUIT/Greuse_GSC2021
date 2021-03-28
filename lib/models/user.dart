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
      'uid': id,
      'name': displayname,
      'email': email,
      'photoUrl': avatarURL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uid'],
      displayname: json['name'],
      email: json['email'],
      avatarURL: json['photoUrl'],
    );
  }
}
