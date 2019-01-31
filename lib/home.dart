import 'package:flutter/material.dart';
import 'dart:async';

// plugins
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

//pages
import 'firebase_list_view.dart';
import 'options.dart';
import 'account_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus;
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
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
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
    if (_connectionStatus == ConnectivityResult.mobile.toString() ||
        _connectionStatus == ConnectivityResult.wifi.toString()) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        bottomNavigationBar: _makeBottom(context),
        appBar: topAppBar(context),
        body: StreamBuilder<Event>(
          stream:
              FirebaseDatabase.instance.reference().child('devices').onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (!event.hasData)
              return new Center(child: CircularProgressIndicator());
            // print(event.data.snapshot.value);
            // return Container();
            return FirebaseListView(documents: event.data.snapshot.value);
          },
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        bottomNavigationBar: _makeBottom(context),
        appBar: topAppBar(context),
        body: Container(
          child: Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No connection',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
