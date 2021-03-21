import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/my_posts_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart';

class MyPostsScreen extends StatefulWidget {
  static const id = 'my_posts_screen';
  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _myPosts = <NewsFeedCardVM>[];

  Future _fetchMyPosts() {
    // TODO: Fetch news feed from sever and add to _newsFeedList
    _myPosts.addAll([
      NewsFeedCardVM(
        user: User(
          id: 'userid',
          username: 'khiemle',
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
        ),
      ),
    ]);
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
