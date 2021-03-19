import 'package:flutter/foundation.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart';

class NewsFeedCardVM {
  final User user;
  final Post post;
  NewsFeedCardVM({@required this.user, @required this.post});
}
