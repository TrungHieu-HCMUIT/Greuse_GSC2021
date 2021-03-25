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
  final _savedPosts = <NewsFeedCardVM>[];

  Future _fetchSavedPosts() {
    // TODO: Fetch news feed from sever and add to _savedPosts
    _savedPosts.addAll([
      NewsFeedCardVM(
        user: User(
          id: 'userid',
          displayname: 'khiemle',
          avatarURL: 'https://wallpapercave.com/wp/wp7999906.jpg',
          email: 'user@email.com',
        ),
        post: Post(
          id: 'postid',
          image:
              'https://thunggiay.com/wp-content/uploads/2018/10/Mua-thung-giay-o-dau-uy-tin-va-chat-luong1.jpg',
          material: 'Paper',
          name: 'Carton Box',
          location: 'TP HCM',
          description: 'Can be reused',
          isSaved: true,
          weight: 10,
        ),
      ),
    ]);
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
          return NewsFeedCard(_savedPosts.elementAt(index));
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 25.0);
        },
      ),
    );
  }
}
