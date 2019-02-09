import 'package:firebase_database/firebase_database.dart';

class DeviceEntry {
  String key;
  String name;
  bool status;

  DeviceEntry(this.name, this.status);

  DeviceEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        status = snapshot.value["status"];

  toJson() {
    return {
      "name": name,
      "status": status,
    };
  }
}
