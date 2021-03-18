import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExchangingLocationsScreen extends StatefulWidget {
  static const id = 'exchanging_locations_screen';
  @override
  _ExchangingLocationsScreenState createState() =>
      _ExchangingLocationsScreenState();
}

class _ExchangingLocationsScreenState extends State<ExchangingLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: Icon(CupertinoIcons.chevron_left),
        ),
        title: Text('Exchanging locations'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(height: 15.0);
        },
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 30.0,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListViewItem();
        },
      ),
    );
  }
}

class ListViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                'assets/images/avatar.png',
                height: 65.0,
                width: 65.0,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enterprise name',
                    style: TextStyle(
                      color: Color(0xFF868686),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Get a personal bamboo water bottle',
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              children: [
                Image.asset(
                  'assets/icons/point.png',
                  width: 42.0,
                  height: 42.0,
                ),
                SizedBox(height: 5.0),
                Text(
                  '599',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
