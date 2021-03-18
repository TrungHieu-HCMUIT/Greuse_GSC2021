import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/screens/messages_screen.dart';
import 'package:greuse/screens/search_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  static const id = 'news_feed_screen';
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Greuse'),
        leading: IconButton(
          icon: Icon(CupertinoIcons.search),
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
