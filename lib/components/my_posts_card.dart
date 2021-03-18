import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPostsCard extends StatelessWidget {
  final String avatarURL;
  final String username;
  final String productImage;
  final String name;
  final String material;
  final String location;
  final String description;
  MyPostsCard({
    @required this.avatarURL,
    @required this.username,
    @required this.productImage,
    @required this.name,
    @required this.material,
    @required this.location,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3.0,
      shadowColor: Colors.black38,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productImage),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 26.0,
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black38,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: NetworkImage(avatarURL),
                              radius: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                username ?? 'Anonymous',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(35.0)),
                              padding: EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 15.0,
                              ),
                              child: Text(
                                material ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 4.0,
                    top: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000.0),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashColor: Colors.black26,
                          highlightColor: Colors.black12,
                          padding: EdgeInsets.zero,
                          tooltip: 'Remove post',
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black.withAlpha(150),
                            size: 34.0,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Name',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      location ?? 'Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  description ?? 'Description',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
