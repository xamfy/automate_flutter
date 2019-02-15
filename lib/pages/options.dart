import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transparent_image/transparent_image.dart';

import 'account_page.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'google_auth.dart';
import '../auth_provider.dart';
import 'add_device.dart';

// final GoogleSignIn _googleSignIn = new GoogleSignIn();

class OptionsPage extends StatefulWidget {
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  void initState() {
    super.initState();
  }

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text('Options'),
  );

  _launchAbout() async {
    const url = 'https://github.com/xamirtz/automate_flutter_client';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _signOut(context) async {
    try {
      // await _googleSignIn.disconnect();
      // await _googleSignIn.signOut();
      var auth = AuthProvider.of(context).auth;
      await FirebaseAuth.instance.signOut();
      await auth.signOutGoogle();
      // print('signed out');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            // Image.asset(
            //   'assets/dashboard.png',
            //   height: 200.0,
            // ),
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage('assets/dashboard.png'),
              height: 200.0,
            ),
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AddDevicePage()));
              },
              child: Text(
                'Add Device',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AccountPage()));
              },
              child: Text(
                'Account',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25.0),
            GestureDetector(
              onTap: () {
                _signOut(context);
              },
              child: Text(
                'Sign out',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // SizedBox(height: 25.0),
            // GestureDetector(
            //   onTap: _launchAbout,
            //   child: Text(
            //     'About',
            //     style: TextStyle(
            //         fontSize: 22.0,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(height: 22.0),
            // Text(
            //   'Support',
            //   style: TextStyle(
            //       fontSize: 22.0,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold),
            // )
          ],
        ),
      ),
    );
  }
}
