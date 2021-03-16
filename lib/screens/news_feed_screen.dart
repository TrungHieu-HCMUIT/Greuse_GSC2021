import 'package:flutter/material.dart';
import 'package:greuse/components/news_feed_card.dart';

class NewsFeedScreen extends StatefulWidget {
  static const id = 'news_feed_screen';
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
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
