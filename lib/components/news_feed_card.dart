import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/screens/chat_screen.dart';
import 'package:greuse/screens/comment_screen.dart';

class NewsFeedCard extends StatelessWidget {
  final NewsFeedCardVM viewModel;
  final Function toggleBookmark;
  final Function toggleLike;
  NewsFeedCard({this.viewModel, this.toggleBookmark, this.toggleLike});

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
          Stack(
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
                      image: NetworkImage(viewModel.post.image),
                    ),
                  ),
                  child: Column(
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
                              Colors.black87,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: NetworkImage(viewModel
                                      .user.avatarURL ??
                                  'https://st.quantrimang.com/photos/image/2017/04/08/anh-dai-dien-FB-200.jpg'),
                              radius: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                viewModel.user.displayname ?? 'Anonymous',
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
                                viewModel.post.material ?? 'Unknown',
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
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 1.0,
                        spreadRadius: 0.5,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/point.png',
                        scale: 6.0,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '599',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Material(
                        child: InkWell(
                          onTap: toggleLike,
                          child: ImageIcon(
                            AssetImage('assets/icons/ThumbsUp.png'),
                            size: 32.0,
                            color: viewModel.post.liked
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CommentScreen.id,
                              arguments: viewModel.post.id,
                            );
                          },
                          child: ImageIcon(
                            AssetImage('assets/icons/ChatTeardropDots.png'),
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ChatScreen.id,
                                arguments: viewModel.user.id);
                          },
                          child: ImageIcon(
                            AssetImage('assets/icons/paper_air_plane_45d.png'),
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Material(
                        child: InkWell(
                          onTap: toggleBookmark,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage(
                                viewModel.post.isSaved
                                    ? 'assets/icons/bookmark_filled.png'
                                    : 'assets/icons/bookmark.png',
                              ),
                              size: 32.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  viewModel.post.name ?? 'Name',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/location.png'),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      viewModel.post.location ?? 'Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  viewModel.post.description ?? 'Description',
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
