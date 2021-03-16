import 'package:flutter/material.dart';
import 'package:greuse/screens/add_screen.dart';
import 'package:greuse/screens/home_screen.dart';
import 'package:greuse/screens/messages_screen.dart';
import 'package:greuse/screens/news_feed_screen.dart';
import 'package:greuse/screens/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF2A9D8F),
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (_) => HomeScreen(),
        NewsFeedScreen.id: (_) => NewsFeedScreen(),
        AddScreen.id: (_) => AddScreen(),
        ProfileScreen.id: (_) => ProfileScreen(),
        MessagesScreen.id: (_) => MessagesScreen(),
      },
    );
  }
}
