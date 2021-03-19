import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greuse/components/floating_bottom_button.dart';
import 'package:greuse/screens/exchanging_locations_screen.dart';
import 'package:greuse/screens/my_posts_screen.dart';
import 'package:greuse/screens/saved_posts_screen.dart';
import 'package:greuse/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final avatarURL = 'https://wallpapercave.com/wp/wp7999906.jpg';
  final username = 'khiemle';

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
                              icon: CupertinoIcons.bookmark_fill,
                              iconColor: Color(0xFFE9C46A),
                              label: 'Saved posts',
                            ),
                          ),
                          SizedBox(width: 14.0),
                          Expanded(
                            child: MyCard(
                              onTap: () {
                                Navigator.pushNamed(context, MyPostsScreen.id);
                              },
                              icon: CupertinoIcons.news_solid,
                              iconColor: Color(0xFFE76F51),
                              label: 'My posts',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListItem(
                  onTap: () {},
                  leading: Image.asset('assets/icons/point.png'),
                  title: 'Greuse points',
                  trailing: Text(
                    '59',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ListItem(
                  onTap: () {
                    Navigator.pushNamed(context, ExchangingLocationsScreen.id);
                  },
                  leading: Image.asset('assets/icons/store.png'),
                  title: 'Exchanging location',
                ),
                ListItem(
                  onTap: () {},
                  leading: Image.asset('assets/icons/exchange.png'),
                  title: 'Exchanging board',
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
  final IconData icon;
  final Color iconColor;
  final String label;
  final Function onTap;
  MyCard({
    @required this.icon,
    @required this.iconColor,
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
                  CircleAvatar(
                    child: Icon(
                      icon ?? Icons.warning,
                      color: iconColor ?? Colors.yellow,
                    ),
                    backgroundColor: iconColor.withAlpha(100),
                  ),
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
