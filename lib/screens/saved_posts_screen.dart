import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/news_feed_card.dart';

class SavedPostsScreen extends StatefulWidget {
  static const id = 'saved_posts_screen';
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: Icon(CupertinoIcons.chevron_left),
        ),
        title: Text('Saved posts'),
      ),
      body: ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: 26.0,
            horizontal: 36.0,
          ),
          itemBuilder: (context, index) {
            return NewsFeedCard(
              username: 'khiemle',
              avatarURL: 'https://wallpapercave.com/wp/wp7999906.jpg',
              material: 'Paper',
              productImage:
                  'https://thunggiay.com/wp-content/uploads/2018/10/Mua-thung-giay-o-dau-uy-tin-va-chat-luong1.jpg',
              name: 'Carton box',
              location: 'TP HCM',
              description: 'Can be reused',
              isSaved: true,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 25.0);
          },
          itemCount: 3),
    );
  }
}
