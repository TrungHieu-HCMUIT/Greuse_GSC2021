import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String image;
  final String name;
  final String location;
  final String description;
  final bool isSaved;
  Post({
    this.id,
    @required this.image,
    @required this.name,
    @required this.location,
    @required this.description,
    this.isSaved,
  });

  Map<String, dynamic> toJson() {
    return {
      id: id,
      image: image,
      name: name,
      location: location,
      description: description,
      'isSaved': isSaved,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      isSaved: json['isSaved'],
    );
  }
}
