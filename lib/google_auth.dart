import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'auth_provider.dart';
import 'home.dart';

// firebase_auth

class GoogleAuth extends StatefulWidget {
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  String _currentUser;

  @override
  void initState() {
    super.initState();
    currentUser().then((v) {
      setState(() {
        _currentUser = v;
        print("_currentUser : " + _currentUser);
      });
    });
  }

  Future<String> currentUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    print("currentUser(): " + user.toString());
    return user.toString();
  }

  Future<FirebaseUser> _signIn(context) async {
    var auth = AuthProvider.of(context).auth;
    FirebaseUser user = await auth.signInWithGoogle();
    return user;
  }

  void _signOut(context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await FirebaseAuth.instance.signOut();
      await auth.signOutGoogle();
      print('signed out');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_currentUser);
    if (_currentUser != "null") {
      print('if');
      return MyHomePage();
    } else {
      // print(currentUser());
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          elevation: 0.1,
          title: Text('Automate'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Log in with Google'),
                onPressed: () => _signIn(context).then((FirebaseUser user) {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => HomePage(
                      //               user: user,
                      //               onSignedOut: () => _signOut(context),
                      //             )));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyHomePage(
                                  // user: user,
                                  // onSignedOut: () => _signOut(context),
                                  )));
                    }).catchError((e) => print(e)),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  final VoidCallback onSignedOut;

  HomePage({this.user, this.onSignedOut});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _signOut(BuildContext context) async {
    try {
      widget.onSignedOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => GoogleAuth()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
          ),
          SizedBox(height: 10.0),
          Text('Welcome ${widget.user.displayName}'),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueAccent,
            onPressed: () => _signOut(context),
          )
        ],
      )),
    );
  }
}
