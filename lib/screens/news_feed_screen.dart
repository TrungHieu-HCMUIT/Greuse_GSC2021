import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/screens/messages_screen.dart';

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
      appBar: AppBar(
        shadowColor: Colors.black.withAlpha(39),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Greuse',
          style: TextStyle(
            color: Color(0xFF264653),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF264653),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.search),
          tooltip: 'Search',
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.paperplane),
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
