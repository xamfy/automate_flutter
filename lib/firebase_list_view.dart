import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference mainReference = FirebaseDatabase.instance.reference();

class FirebaseListView extends StatelessWidget {
  final documents;

  FirebaseListView({this.documents});

  @override
  Widget build(BuildContext context) {
    print(documents);
    if (documents != null) {
      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          Map<dynamic, dynamic> object = documents[index];
          print(object);
          String title = object['name'];
          print(title);
          bool status = object['status'];
          Color c = (status == true) ? Colors.indigo : Colors.grey;
          Color iconColor = (status == true) ? Colors.greenAccent : Colors.grey;
          return Card(
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
                    Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconColor,
                        )),
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
              ),
            ),
          );
        },
      );
    }
  }
}
