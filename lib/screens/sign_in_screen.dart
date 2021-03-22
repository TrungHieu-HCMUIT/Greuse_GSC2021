import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greuse/screens/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class SignInScreen extends StatefulWidget {
  static const id = 'sign_in_screen';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _emailErrorText;
  String _passwordErrorText;

  Future _signIn() async {
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } catch (e) {
        setState(() {
          switch (e.code) {
            case 'invalid-email':
              _emailErrorText = 'Please enter a valid email';
              break;
            case 'user-disabled':
              _emailErrorText = 'This user has been disabled';
              break;
            case 'user-not-found':
              _emailErrorText = 'User not found';
              break;
            case 'wrong-password':
              _passwordErrorText = 'Wrong password';
              break;
            default:
          }
        });
      }
    }
  }

  String _emailValidator(String email) {
    if (email.isEmpty) return 'Please enter your email';
    final emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool emailValid = emailRegEx.hasMatch(email);
    if (!emailValid) return 'Please enter a valid email';
    return null;
  }

  String _passwordValidator(String password) {
    if (password.isEmpty) return 'Please enter your password';
    return null;
  }

  void _onEmailSaved(String email) {
    _email = email;
  }

  void _onPasswordSaved(String password) {
    _password = password;
    return null;
  }

  void getUserProfileFirestore() async {
    // TODO: Update user profile when sign in if not exits
    final signInUser = _auth.currentUser;

    if (signInUser != null) {
      final userRef = _firestore.collection('users').doc(signInUser.uid);

      // await userRef.get().then((value) => {
      //       if (!value.exists)
      //         {
      userRef.set({
        'email': signInUser.email,
        'uid': signInUser.uid,
        'name': signInUser.displayName,
        'isEmailVerified': signInUser.emailVerified,
        'photoUrl': signInUser.photoURL,
        'points': 0,
        //   })
        // }
      });
    }
  }

  void _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      getUserProfileFirestore();
    } catch (e) {
      print(e);
    }
  }

  void _signInWithFacebook() {
    // TODO: Implement signin with facebook
  }

  void _signUp() {
    Navigator.pushNamed(context, SignUpScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/icons/app_logo.png',
                        scale: 3.0,
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _emailErrorText,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _emailValidator,
                        onSaved: _onEmailSaved,
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _passwordErrorText,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        validator: _passwordValidator,
                        onChanged: _onPasswordSaved,
                      ),
                      SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: _signIn,
                        child: Text('SIGN IN'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(165, 45),
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      OutlinedButton.icon(
                        onPressed: _signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(250, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            primary: Colors.blueGrey,
                            textStyle: TextStyle(
                              fontSize: 18,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            )),
                        icon: Image.asset(
                          'assets/icons/google.png',
                          scale: 16.5,
                        ),
                        label: Text('Sign in with Google'),
                      ),
                      SizedBox(height: 5.0),
                      OutlinedButton.icon(
                        onPressed: _signInWithFacebook,
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(250, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            primary: Colors.blueGrey,
                            textStyle: TextStyle(
                              fontSize: 18,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            )),
                        icon: Image.asset(
                          'assets/icons/facebook.png',
                          scale: 16.5,
                        ),
                        label: Text('Sign in with Facebook'),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont't have an account? ",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                GestureDetector(
                  onTap: _signUp,
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                    ),
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
