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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
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
          // Map<String, dynamic> user = jsonDecode(documents);
          // bool status = documents['led'].data['status'];
          return Card(
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(fontSize: 18.0),
              ),
              // subtitle: Text(''),
              trailing: Switch(
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
          );
        },
      );
    }
  }
}
