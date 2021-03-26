import 'package:flutter/foundation.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart';

class NewsFeedCardVM {
  final User user;
  final Post post;
  NewsFeedCardVM({@required this.user, @required this.post});

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'post': post.toJson(),
    };
  }

  factory NewsFeedCardVM.fromJson(Map<String, dynamic> json) {
    return NewsFeedCardVM(
      post: Post.fromJson(json['post']),
      user: User.fromJson(json['user']),
    );
  }
}
