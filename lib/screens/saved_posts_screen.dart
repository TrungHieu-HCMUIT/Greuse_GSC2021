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
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black.withAlpha(39),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF264653),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: Icon(CupertinoIcons.chevron_left),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF264653),
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
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
            return NewsFeedCard();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 25.0);
          },
          itemCount: 3),
    );
  }
}
