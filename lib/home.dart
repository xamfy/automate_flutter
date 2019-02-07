import 'package:flutter/material.dart';
import 'dart:async';

// plugins
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

//pages
import 'pages/firebase_list_view.dart';
import 'pages/options.dart';
import 'pages/account_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus;

  SharedPreferences prefs;
  String id = '';
  String nickname = '';
  String email = '';
  String photoUrl = '';

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    nickname = prefs.getString('nickname');
    email = prefs.getString('email');
    photoUrl = prefs.getString('photoUrl');
    // print("photoUrl:" + photoUrl);
    // print("id: " + id);
    // Force refresh input
    setState(() {});
  }

  StreamSubscription<ConnectivityResult> _connectionSubscription;

  // _snack() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //     final snackBar = SnackBar(content: Text('Online'));

  //     // Find the Scaffold in the Widget tree and use it to show a SnackBar
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   } else if (connectivityResult == ConnectivityResult.none) {
  //     // I am connected to a wifi network.
  //     final snackBar = SnackBar(content: Text('Offline'));

  //     // Find the Scaffold in the Widget tree and use it to show a SnackBar
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    readLocal();
    _connectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      setState(() {
        _connectionStatus = result.toString();
        // print("Connection : $_connectionStatus");
      });
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  Widget topAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      automaticallyImplyLeading: false,
      title: Text('Automate'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OptionsPage()));
          },
        )
      ],
    );
  }

  _makeBottom(BuildContext context) {
    return Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            // IconButton(
            //   icon: Icon(Icons.blur_on, color: Colors.white),
            //   onPressed: () {},
            // ),
            // IconButton(
            //   icon: Icon(Icons.hotel, color: Colors.white),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AccountPage()));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_connectionStatus == ConnectivityResult.mobile.toString() ||
    //     _connectionStatus == ConnectivityResult.wifi.toString()) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      // bottomNavigationBar: _makeBottom(context),
      appBar: topAppBar(context),
      body: StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child('devices')
            .child(id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData)
            return new Center(child: CircularProgressIndicator());
          // print(event.data.snapshot.value);
          // return Container();
          return FirebaseListView(
            documents: event.data.snapshot.value,
            id: id,
          );
        },
      ),
    );
  }
  // else {
  //   return Scaffold(
  //     backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  //     bottomNavigationBar: _makeBottom(context),
  //     appBar: topAppBar(context),
  //     body: Container(
  //       child: Center(
  //         child: Container(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 'No connection',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 19.0),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
