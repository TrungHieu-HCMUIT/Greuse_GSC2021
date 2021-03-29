import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart' as us;

class SavedPostsScreen extends StatefulWidget {
  static const id = 'saved_posts_screen';
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var _savedPosts = <NewsFeedCardVM>[];

  Future<void> _fetchSavedPosts() async {
    _savedPosts.clear();
    final userId = _auth.currentUser.uid;
    final posts = (await _firestore
            .collection("users")
            .doc(userId)
            .collection("savedPosts")
            .get())
        .docs;
    for (int i = 0; i < posts.length; i++) {
      final postData = (await posts[i].data()['post'].get()).data();
      if (postData == null) {
        await _firestore
            .collection("users")
            .doc(userId)
            .collection("savedPosts")
            .doc(posts[i].id)
            .delete();
        continue;
      }
      final userData = (await postData['user'].get()).data();

      final liked = (await _firestore
                  .collection('users')
                  .doc(userId)
                  .collection("likedPosts")
                  .where('id', isEqualTo: postData['id'])
                  .get())
              .size ==
          1;

      _savedPosts.add(NewsFeedCardVM(
        user: us.User.fromJson(userData),
        post: Post.fromJson({
          ...postData,
          'isSaved': true,
          'liked': liked,
        }),
      ));
    }
    setState(() {});
  }

  Future<void> _toggleBookmark(int pos, NewsFeedCardVM vm) async {
    final userId = _auth.currentUser.uid;
    print(userId);
    final snap = await _firestore
        .collection("users")
        .doc(userId)
        .collection("savedPosts")
        .where("id", isEqualTo: vm.post.id)
        .get();
    if (snap.size == 0) {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("savedPosts")
          .add({
        'id': vm.post.id,
        'post': _firestore.doc('posts/${vm.post.id}'),
      });
    } else {
      await _firestore
          .doc('users/$userId/savedPosts/${snap.docs[0].id}')
          .delete();
    }
    setState(() {
      print(vm.post.toJson());
      _savedPosts[pos] = NewsFeedCardVM(
        post: Post.fromJson({
          ...vm.post.toJson(),
          'isSaved': !vm.post.isSaved,
        }),
        user: vm.user,
      );
    });
  }

  Future<void> _toggleLike(int pos, NewsFeedCardVM vm) async {
    final userId = _auth.currentUser.uid;
    final snap = await _firestore
        .collection("users")
        .doc(userId)
        .collection("likedPosts")
        .where("id", isEqualTo: vm.post.id)
        .get();
    if (snap.size == 0) {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("likedPosts")
          .add({
        'id': vm.post.id,
        'post': _firestore.doc('posts/${vm.post.id}'),
      });
    } else {
      await _firestore
          .doc('users/$userId/likedPosts/${snap.docs[0].id}')
          .delete();
    }
    setState(() {
      _savedPosts[pos] = NewsFeedCardVM(
        post: Post.fromJson({
          ...vm.post.toJson(),
          'liked': !vm.post.liked,
        }),
        user: vm.user,
      );
    });
  }

  @override
  void initState() {
    _fetchSavedPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: ImageIcon(AssetImage('assets/icons/back.png')),
        ),
        title: Text('Saved posts'),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 26.0,
          horizontal: 36.0,
        ),
        itemCount: _savedPosts.length,
        itemBuilder: (context, index) {
          final e = _savedPosts.elementAt(index);
          return NewsFeedCard(
              viewModel: e,
              toggleBookmark: () => _toggleBookmark(index, e),
              toggleLike: () => _toggleLike(index, e),
              message: e.user.id != _auth.currentUser.uid);
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 25.0);
        },
      ),
    );
  }
}
