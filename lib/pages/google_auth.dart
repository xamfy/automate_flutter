import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../auth_provider.dart';
import '../home.dart';

// firebase_auth

DatabaseReference mainReference = FirebaseDatabase.instance.reference();

class GoogleAuth extends StatefulWidget {
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  String _currentUser;
  SharedPreferences prefs;
  bool _isLoading = false;

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  void initState() {
    super.initState();
    currentUser().then((v) {
      setState(() {
        _currentUser = v;
        // print("_currentUser : " + _currentUser);
      });
    });
  }

  Future<String> currentUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    // print("currentUser(): " + user.toString());
    return user.toString();
  }

  Future<FirebaseUser> _signIn(context) async {
    setState(() {
      _isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();

    var auth = AuthProvider.of(context).auth;
    FirebaseUser user = await auth.signInWithGoogle();
    await prefs.setString('id', user.uid);
    await prefs.setString('nickname', user.displayName);
    await prefs.setString('photoUrl', user.photoUrl);
    await prefs.setString('email', user.email);
    // print(user.photoUrl);
    String s = prefs.getString('photoUrl');
    // print("photoUrl (signIn):" + s);

    setState(() {
      _isLoading = false;
    });
    // mainReference
    //     .child('devices')
    //     .child(user.uid)
    //     .once()
    //     .then((DataSnapshot data) {
    //   // print("data-key : " + data.key);
    //   // print("data-value : " + data.value.toString());
    // });
    return user;
  }

  void _signOut(context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await FirebaseAuth.instance.signOut();
      await auth.signOutGoogle();
      // print('signed out');
    } catch (e) {
      print(e);
    }
  }

  Widget _body(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Automate',
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Image.asset(
            'assets/home.png',
            height: 250.0,
          ),
          // SizedBox(height: 20.0),
          new RaisedButton(
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
            color: Colors.white,
            child: new Container(
              width: 230.0,
              height: 50.0,
              alignment: Alignment.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    // child: CachedNetworkImage(
                    //   imageUrl:
                    //       'https://developers.google.com/identity/images/g-logo.png',
                    //   width: 30.0,
                    // ),
                    child: Image.asset(
                      'assets/g-logo.png',
                      height: 30.0,
                    ),
                  ),
                  new Text(
                    'Sign in With Google',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // RaisedButton(
          //   child: Text('Log in with Google'),
          //   onPressed: () => _signIn(context).then((FirebaseUser user) {
          //         // Navigator.pushReplacement(
          //         //     context,
          //         //     MaterialPageRoute(
          //         //         builder: (BuildContext context) => HomePage(
          //         //               user: user,
          //         //               onSignedOut: () => _signOut(context),
          //         //             )));
          //         Navigator.pushReplacement(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) => MyHomePage(
          //                     // user: user,
          //                     // onSignedOut: () => _signOut(context),
          //                     )));
          //       }).catchError((e) => print(e)),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(_currentUser);
    if (_currentUser != "null") {
      // print('if');
      return MyHomePage();
    } else {
      // print(currentUser());
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        // appBar: AppBar(
        //   elevation: 0.1,
        //   title: Text('Automate'),
        //   automaticallyImplyLeading: false,
        // ),
        body: Stack(
          children: <Widget>[
            _body(context),
            _showCircularProgress(),
          ],
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
