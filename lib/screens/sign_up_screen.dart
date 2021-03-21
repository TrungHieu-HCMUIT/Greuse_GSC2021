import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class SignUpScreen extends StatefulWidget {
  static const id = 'sign_up_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _email;
  String _displayname;
  String _password;

  String _emailErrorText;

  String _emailValidator(String email) {
    email = email.trim();
    if (email.isEmpty) return 'Please enter your email';
    final emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool emailValid = emailRegEx.hasMatch(email);
    if (!emailValid) return 'Please enter a valid email';
    return null;
  }

  void _onEmailSaved(String email) => _email = email.trim();

  String _displaynameValidator(String displayname) {
    displayname = displayname.trim();
    if (displayname.isEmpty) return 'Please enter your Display Name';
    if (displayname.length < 6)
      return 'displayname must be at least 6 characters';
    return null;
  }

  void _ondisplaynameSaved(String displayname) =>
      _displayname = displayname.trim();

  String _passwordValidator(String password) {
    if (password.isEmpty) return 'Please enter password';
    if (password.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _onPasswordSaved(String password) => _password = password;

  String _confirmPasswordValidator(String password) {
    if (password != _passwordController.text) return 'Password does not match';
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (newUser != null) {
          _firestore.collection('users').add({
            'email': newUser.user.email,
            'uid': newUser.user.uid,
            'name': _displayname,
            'isEmailVerified': newUser.user.emailVerified,
            'photoUrl': "https://wallpapercave.com/wp/wp7999906.jpg",
          });
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          switch (e.code) {
            case 'email-already-in-use':
              _emailErrorText = "Email already in use";
              break;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text('Sign up'),
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     tooltip: 'Back',
      //     icon: Icon(CupertinoIcons.chevron_left),
      //   ),
      // ),
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Display name',
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
                        textInputAction: TextInputAction.next,
                        validator: _displaynameValidator,
                        onSaved: _ondisplaynameSaved,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: _passwordValidator,
                        onSaved: _onPasswordSaved,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
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
                        obscureText: true,
                        validator: _confirmPasswordValidator,
                      ),
                      SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: Text('Sign up'),
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
                  "Already have an account? ",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Sign in",
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
