import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('flutter_data').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return FirestoreListView(documents: snapshot.data.documents);
          },
        ));
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        String title = documents[index].data['device'].toString();
        bool status = documents[index].data['status'];
        return ListTile(
          title: Container(
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5.0),
            //     border: Border.all(color: Colors.black)),
            // padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                Text(title),
                Switch(
                  value: status,
                  onChanged: (e) {
                    Firestore.instance
                        .runTransaction((Transaction transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);
                      await transaction.update(
                          snapshot.reference, {"status": !snapshot["status"]});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
