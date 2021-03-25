import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/my_posts_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart' as us;

class MyPostsScreen extends StatefulWidget {
  static const id = 'my_posts_screen';
  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _myPosts = <NewsFeedCardVM>[];

  Future<void> _fetchMyPosts() async {
    _myPosts.clear();
    final user = _firestore.collection('users').doc(_auth.currentUser.uid);
    final posts = (await _firestore
            .collection('posts')
            .where('user', isEqualTo: user)
            .get())
        .docs;
    for (int i = 0; i < posts.length; i++) {
      final userId = _auth.currentUser.uid;
      final postData = posts[i].data();
      final userData = (await postData['user'].get()).data();
      final isSaved = (await _firestore
                  .collection('users')
                  .doc(userId)
                  .collection("savedPosts")
                  .where('id', isEqualTo: postData['id'])
                  .get())
              .size ==
          1;
      _myPosts.add(NewsFeedCardVM(
        user: us.User.fromJson(userData),
        post: Post.fromJson({
          ...postData,
          'isSaved': isSaved,
        }),
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    _fetchMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: ImageIcon(AssetImage('assets/icons/back.png')),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('My posts'),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 26.0,
          horizontal: 36.0,
        ),
        itemCount: _myPosts.length,
        itemBuilder: (context, index) {
          return MyPostsCard(_myPosts.elementAt(index));
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 25.0);
        },
      ),
    );
  }
}
