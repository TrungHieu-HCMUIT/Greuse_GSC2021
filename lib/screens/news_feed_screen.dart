import 'package:flutter/material.dart';

class NewsFeedScreen extends StatefulWidget {
  static const id = 'news_feed_screen';
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('News feed'),
      ),
    );
  }
}
