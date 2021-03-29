import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greuse/screens/add_screen.dart';
import 'package:greuse/screens/auth_screen.dart';
import 'package:greuse/screens/chat_screen.dart';
import 'package:greuse/screens/choose_location_screen.dart';
import 'package:greuse/screens/comment_screen.dart';
import 'package:greuse/screens/home_screen.dart';
import 'package:greuse/screens/messages_screen.dart';
import 'package:greuse/screens/my_posts_screen.dart';
import 'package:greuse/screens/news_feed_screen.dart';
import 'package:greuse/screens/points_screen.dart';
import 'package:greuse/screens/profile_screen.dart';
import 'package:greuse/screens/saved_posts_screen.dart';
import 'package:greuse/screens/sign_in_screen.dart';
import 'package:greuse/screens/sign_up_screen.dart';
import 'package:greuse/screens/material_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _routes = {
    HomeScreen.id: (_) => HomeScreen(),
    NewsFeedScreen.id: (_) => NewsFeedScreen(),
    AddScreen.id: (_) => AddScreen(),
    ProfileScreen.id: (_) => ProfileScreen(),
    MessagesScreen.id: (_) => MessagesScreen(),
    SavedPostsScreen.id: (_) => SavedPostsScreen(),
    MyPostsScreen.id: (_) => MyPostsScreen(),
    SignInScreen.id: (_) => SignInScreen(),
    SignUpScreen.id: (_) => SignUpScreen(),
    AuthScreen.id: (_) => AuthScreen(),
    PointsScreen.id: (_) => PointsScreen(),
    // ChatScreen.id: (_) => ChatScreen(),
    ChooseLocationScreen.id: (_) => ChooseLocationScreen(),
    MaterialInfoScreen.id: (_) => MaterialInfoScreen(),
    // CommentScreen.id: (_) => CommentScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF2A9D8F),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Color(0xFF264653),
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Color(0xFF264653),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          shadowColor: Colors.black.withAlpha(39),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(
            fontSize: 12.0,
          ),
          backgroundColor: Colors.white,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF2A9D8F),
          textTheme: ButtonTextTheme.primary,
          padding: EdgeInsets.all(12.0),
        ),
      ),
      initialRoute: AuthScreen.id,
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            if (settings.name == CommentScreen.id) {
              return CommentScreen(settings.arguments);
            }
            if (settings.name == ChatScreen.id) {
              return ChatScreen(settings.arguments);
            }
            return _routes[settings.name](context);
          },
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: Offset(1, 0),
                  end: Offset(0, 0),
                ).chain(
                  CurveTween(curve: Curves.ease),
                ),
              ),
              child: ScaleTransition(
                scale: animation.drive(Tween(begin: 0.6, end: 1.0)),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
