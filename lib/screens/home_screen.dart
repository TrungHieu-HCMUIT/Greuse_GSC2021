import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/screens/add_screen.dart';
import 'package:greuse/screens/news_feed_screen.dart';
import 'package:greuse/screens/points_screen.dart';
import 'package:greuse/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          NewsFeedScreen(),
          AddScreen(),
          PointsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/plus.png')),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/gift.png')),
            label: 'Points',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
