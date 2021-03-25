import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart' as us;
import 'package:greuse/screens/messages_screen.dart';
import 'package:greuse/screens/search_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  static const id = 'news_feed_screen';
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var _newsFeedList = <NewsFeedCardVM>[];

  Future<void> _fetchNewsFeed() async {
    _newsFeedList.clear();
    final posts = (await _firestore.collection("posts").get()).docs;
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
      _newsFeedList.add(NewsFeedCardVM(
        user: us.User.fromJson(userData),
        post: Post.fromJson({
          ...postData,
          'isSaved': isSaved,
        }),
      ));
    }
    setState(() {});
  }

  Future<void> _toggleBookmark(int pos, NewsFeedCardVM vm) async {
    // await _firestore.collection("posts").doc(vm.post.id).update({
    //   'isSaved': !vm.post.isSaved,
    // });
    // setState(() {
    //   print(vm.post.toJson());
    //   _newsFeedList[pos] = NewsFeedCardVM(
    //     post: Post.fromJson({
    //       ...vm.post.toJson(),
    //       'isSaved': !vm.post.isSaved,
    //     }),
    //     user: vm.user,
    //   );
    // });
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
      _newsFeedList[pos] = NewsFeedCardVM(
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
    _fetchNewsFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/icons/app_logo.png',
          scale: 9.5,
        ),
        leading: IconButton(
          icon: ImageIcon(AssetImage('assets/icons/search.png')),
          tooltip: 'Search',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SearchScreen();
                },
                transitionDuration: Duration(milliseconds: 300),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(
                        begin: Offset(-0.9, -0.9),
                        end: Offset(0.0, 0.0),
                      ).chain(
                        CurveTween(
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    child: ScaleTransition(
                      scale: animation.drive(
                        Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(
                          CurveTween(
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: ImageIcon(AssetImage('assets/icons/paper_air_plane_45d.png')),
            tooltip: 'Messages',
            onPressed: () {
              Navigator.pushNamed(context, MessagesScreen.id);
            },
          ),
        ],
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 26.0,
          horizontal: 36.0,
        ),
        itemCount: _newsFeedList.length,
        itemBuilder: (context, index) {
          final e = _newsFeedList.elementAt(index);
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
