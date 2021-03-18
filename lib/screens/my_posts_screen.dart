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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_left),
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
          itemBuilder: (context, index) {
            return MyPostsCard(
              username: 'khiemle',
              avatarURL: 'https://wallpapercave.com/wp/wp7999906.jpg',
              material: 'Paper',
              productImage:
                  'https://thunggiay.com/wp-content/uploads/2018/10/Mua-thung-giay-o-dau-uy-tin-va-chat-luong1.jpg',
              name: 'Carton box',
              location: 'TP HCM',
              description: 'Can be reused',
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 25.0);
          },
          itemCount: 3),
    );
  }
}
