import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greuse/screens/home_screen.dart';
import 'package:greuse/screens/sign_in_screen.dart';

class AuthScreen extends StatelessWidget {
  static const id = 'auth_screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        }
        return SignInScreen();
      },
    );
  }
}
