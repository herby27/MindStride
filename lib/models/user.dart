import 'package:cloud_firestore/cloud_firestore.dart';

///****************************************************************************
///MATTHEW HERBERT 2024
///This file defines a Dart class (User) that represents a user's information.
///This class is used to create user objects, convert user objects to JSON format, and create user objects from Firestore document snapshots
///****************************************************************************

class MindStrideUser {
  ///These are the fields of the FireBase database
  String name;
  String email;
  String uid; //The "User ID"
  int role;

  ///The constructor to initialize these fields.
  MindStrideUser({
    required this.name,
    required this.email,
    required this.uid,
    this.role = 1, // regular user: role = 1; admin user: role = 0
  });

///In order to store data about user objects in FireBase, the user objects must be converted to a Json format
  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "uid": uid,
    "role": role,
  };

  ///In order to store data about user objects that's been retrieved from FireBase, the data must be converted from a Json format into strings
  static MindStrideUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MindStrideUser(
      email: snapshot['email'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      role: snapshot['role'] ?? 1, ///If the role field doesn't exist in the snapshot's data, it defaults to the value 1.
    );
  }
}