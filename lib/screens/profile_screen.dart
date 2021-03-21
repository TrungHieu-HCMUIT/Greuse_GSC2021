import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greuse/components/floating_bottom_button.dart';
import 'package:greuse/screens/my_posts_screen.dart';
import 'package:greuse/screens/saved_posts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  String avatarURL = "https://wallpapercave.com/wp/wp7999906.jpg";
  String username = "";
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final userID = _auth.currentUser.uid;
      final user = await _firestore.collection('users').doc(userID).get();
      if (user != null) {
        // TODO: Get current user from firestore
        print(user.data());
        avatarURL = user.data()['photoUrl'];
        username = user.data()['name'];
        userPoints = user.data()['points'];
      }
    } catch (e) {
      print(e);
    }
  }

  void _signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingBottomButton(
        label: 'Log out',
        onPressed: _signOut,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 65.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(avatarURL),
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 55.0,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              username ?? 'Anonymous',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Row(
                        children: [
                          Expanded(
                            child: MyCard(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SavedPostsScreen.id);
                              },
                              icon: Image.asset(
                                'assets/icons/saved_post.png',
                                scale: 2.4,
                              ),
                              label: 'Saved posts',
                            ),
                          ),
                          SizedBox(width: 14.0),
                          Expanded(
                            child: MyCard(
                              onTap: () {
                                Navigator.pushNamed(context, MyPostsScreen.id);
                              },
                              icon: Image.asset(
                                'assets/icons/my_posts.png',
                                scale: 2.4,
                              ),
                              label: 'My posts',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/point.png',
                        scale: 1.2,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "$userPoints",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final Function onTap;
  ListItem({
    @required this.leading,
    @required this.title,
    this.trailing,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        child: Row(
          children: [
            SizedBox(
              width: 48.0,
              height: 48.0,
              child: leading,
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            trailing ?? Icon(CupertinoIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final Function onTap;
  MyCard({
    @required this.icon,
    @required this.label,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: Color(0xFFF1F1F1),
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  SizedBox(height: 12.0),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
