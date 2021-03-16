import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/screens/add_screen.dart';
import 'package:greuse/screens/news_feed_screen.dart';
import 'package:greuse/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _screens = [
    NewsFeedScreen(),
    AddScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_currentIndex),
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
            tooltip: 'Message',
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
