import 'package:flutter/material.dart';

// plugins
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String username = '';
  String photo = '';
  String email = '';

  void initState() {
    super.initState();
    currentUser();
  }

  Future<void> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    username = user.displayName;
    photo = user.photoUrl;
    email = user.email;
    print(user.email);
    setState(() {});
    // return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    // print(currentUser());

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('Account'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Container(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.0),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(photo),
                maxRadius: 50.0,
              ),
              SizedBox(height: 35.0),
              Container(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      email,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
