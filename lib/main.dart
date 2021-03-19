import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greuse/screens/add_screen.dart';
import 'package:greuse/screens/exchanging_locations_screen.dart';
import 'package:greuse/screens/home_screen.dart';
import 'package:greuse/screens/messages_screen.dart';
import 'package:greuse/screens/my_posts_screen.dart';
import 'package:greuse/screens/news_feed_screen.dart';
import 'package:greuse/screens/profile_screen.dart';
import 'package:greuse/screens/saved_posts_screen.dart';
import 'package:greuse/screens/sign_in_screen.dart';
import 'package:greuse/screens/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _routes = {
    HomeScreen.id: (_) => HomeScreen(),
    NewsFeedScreen.id: (_) => NewsFeedScreen(),
    AddScreen.id: (_) => AddScreen(),
    ProfileScreen.id: (_) => ProfileScreen(),
    MessagesScreen.id: (_) => MessagesScreen(),
    SavedPostsScreen.id: (_) => SavedPostsScreen(),
    MyPostsScreen.id: (_) => MyPostsScreen(),
    ExchangingLocationsScreen.id: (_) => ExchangingLocationsScreen(),
    SignInScreen.id: (_) => SignInScreen(),
    SignUpScreen.id: (_) => SignUpScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error. Please reopen the app!'),
                ),
              ),
            );
          }
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
                backgroundColor: Colors.white,
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Color(0xFF2A9D8F),
                textTheme: ButtonTextTheme.primary,
                padding: EdgeInsets.all(12.0),
              ),
            ),
            initialRoute: SignInScreen.id,
            onGenerateRoute: (settings) {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return _routes[settings.name](context);
                },
                transitionDuration: Duration(milliseconds: 300),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
        });
  }
}
