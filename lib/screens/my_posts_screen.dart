import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/my_posts_card.dart';

class MyPostsScreen extends StatefulWidget {
  static const id = 'my_posts_screen';
  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withAlpha(39),
        iconTheme: IconThemeData(
          color: Color(0xFF264653),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_left),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My posts',
          style: TextStyle(
            color: Color(0xFF264653),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: 26.0,
            horizontal: 36.0,
          ),
          itemBuilder: (context, index) {
            return MyPostsCard();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 25.0);
          },
          itemCount: 3),
    );
  }
}
