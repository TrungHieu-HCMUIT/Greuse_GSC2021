import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  static const id = 'messages_screen';
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black.withAlpha(39),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF264653),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: Icon(CupertinoIcons.chevron_left),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF264653),
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text('Messages'),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return SizedBox(height: 18.0);
        },
        padding: EdgeInsets.all(32.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 28.0,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'trunghieu',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
