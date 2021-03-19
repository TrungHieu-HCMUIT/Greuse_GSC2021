import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greuse/screens/home_screen.dart';
import 'package:greuse/screens/sign_up_screen.dart';

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

  void _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  void _signUp() {
    Navigator.pushNamed(context, SignUpScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _emailErrorText,
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _emailValidator,
                  onSaved: _onEmailSaved,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordErrorText,
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  validator: _passwordValidator,
                  onChanged: _onPasswordSaved,
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: _signIn,
                  child: Text('Sign in'),
                ),
                SizedBox(height: 30.0),
                Text(
                  'Or',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  onPressed: _signInWithGoogle,
                  color: Colors.red,
                  child: Text(
                    'Sign in with Google',
                  ),
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: _signUp,
                  color: Colors.green,
                  child: Text(
                    'Sign up',
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
