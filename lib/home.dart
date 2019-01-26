import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

DatabaseReference mainReference = FirebaseDatabase.instance.reference();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text('Automate'),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {},
      )
    ],
  );

  final makeBottom = Container(
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
            onPressed: () {},
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      bottomNavigationBar: makeBottom,
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(widget.title),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.settings),
      //       onPressed: () {},
      //     )
      //   ],
      // ),
      appBar: topAppBar,
      body: StreamBuilder<Event>(
        stream: FirebaseDatabase.instance.reference().child('devices').onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData)
            return new Center(child: CircularProgressIndicator());
          // print(event.data.snapshot.value);
          // return Container();
          return FirestoreListView(documents: event.data.snapshot.value);
        },
      ),
    );
  }
}

class FirestoreListView extends StatelessWidget {
  final documents;

  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    print(documents);
    if (documents != null) {
      return ListView.builder(
        itemCount: documents.length,
        // itemExtent: 90.0,
        itemBuilder: (BuildContext context, int index) {
          Map<dynamic, dynamic> object = documents[index];
          print(object);
          String title = object['name'];
          print(title);
          bool status = object['status'];
          Color c = (status == true) ? Colors.indigo : Colors.grey;
          Color iconColor =
              (status == true) ? Colors.greenAccent : Colors.yellowAccent;
          // Map<String, dynamic> user = jsonDecode(documents);
          // bool status = documents['led'].data['status'];
          return Card(
            // shape: RoundedRectangleBorder(
            //     side: new BorderSide(color: Colors.blue, width: 2.0),
            //     borderRadius: BorderRadius.circular(10.0)),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(15.0),
            // ),

            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            color: c,
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                title: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.stop, color: iconColor),
                    // Text("", style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Switch(
                  activeColor: Colors.white,
                  value: status,
                  onChanged: (e) {
                    status = !status;
                    mainReference
                        .child('devices')
                        .child(index.toString())
                        .set({"name": title, "status": status});
                  },
                ),
                // title: Container(
                //   child: Row(
                //     children: <Widget>[
                //       Text(title),
                // Switch(
                //   value: status,
                //   onChanged: (e) {
                //     status = !status;
                //     mainReference
                //         .child('devices')
                //         .child(index.toString())
                //         .set({"name": title, "status": status});
                //   },
                // ),
                //     ],
                //   ),
                // ),
              ),
            ),
          );
        },
      );
    }
  }
}
