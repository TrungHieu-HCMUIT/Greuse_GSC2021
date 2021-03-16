import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  static const id = 'add_screen';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Add'),
      ),
    );
  }
}
