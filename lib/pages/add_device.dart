import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_automation/models/device.dart';

final mainReference = FirebaseDatabase.instance.reference();

class AddDevicePage extends StatelessWidget {
  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text('Add Device'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: DeviceForm(),
    );
  }
}

class DeviceForm extends StatefulWidget {
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  DeviceEntry d;
  SharedPreferences prefs;
  String uid = '';
  DeviceEntry device;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  final deviceController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    deviceController.dispose();
    super.dispose();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('id');
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(30.0),
      child: Form(
        key: this._formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.characters,
              // autofocus: true,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              controller: deviceController,
              decoration: InputDecoration(
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  // fillColor: Colors.white70
                  // hintText: "Type in your text",
                  labelText: 'Device name',
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  errorStyle: TextStyle(color: Colors.white),
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    // borderRadius: const BorderRadius.all(
                    //   const Radius.circular(10.0),
                    // ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.white)),

                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  //   borderSide: BorderSide(
                  //       color: Colors.white,
                  //       width: 1.0,
                  //       style: BorderStyle.solid),
                  // ),
                  enabledBorder: new OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  // isDense: true,
                  // icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                  // border: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.white),
                  // ),
                  // enabledBorder: const OutlineInputBorder(
                  //   // width: 0.0 produces a thin "hairline" border
                  //   borderSide: const BorderSide(color: Colors.white),
                  // ),
                  // border: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.white),
                  // ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter device name';
                }
              },
            ),
            Container(
              width: screenSize.width,
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Add Device',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () {
                  // print(deviceController.text);
                  FocusScope.of(context).requestFocus(new FocusNode());
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, we want to show a Snackbar
                    DeviceEntry device =
                        DeviceEntry(deviceController.text, false);
                    mainReference
                        .child('devices')
                        .child(uid)
                        .push()
                        .set(device.toJson());
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Device added')));
                    deviceController.clear();
                  }
                },
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
