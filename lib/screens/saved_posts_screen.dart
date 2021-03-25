import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart';

class SavedPostsScreen extends StatefulWidget {
  static const id = 'saved_posts_screen';
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  final _firestore = FirebaseFirestore.instance;
  var _savedPosts = <NewsFeedCardVM>[];

  Future<void> _fetchSavedPosts() async {
    _savedPosts.clear();
    final posts = (await _firestore
            .collection("posts")
            .where('isSaved', isEqualTo: true)
            .get())
        .docs;
    for (int i = 0; i < posts.length; i++) {
      final postData = posts[i].data();
      final userData = (await postData['user'].get()).data();
      _savedPosts.add(NewsFeedCardVM(
        user: User.fromJson(userData),
        post: Post.fromJson(postData),
      ));
    }
    setState(() {});
  }

  Future<void> _toggleBookmark(int pos, NewsFeedCardVM vm) async {
    await _firestore.collection("posts").doc(vm.post.id).update({
      'isSaved': !vm.post.isSaved,
    });
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
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 25.0);
        },
      ),
    );
  }
}
