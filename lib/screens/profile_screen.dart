import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
