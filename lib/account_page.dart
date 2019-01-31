import 'package:flutter/material.dart';

// plugins
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                backgroundImage:
                    CachedNetworkImageProvider('https://bit.ly/2p9CQul'),
                maxRadius: 50.0,
              ),
              SizedBox(height: 35.0),
              Container(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'John Doe',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      'john@example.com',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
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
