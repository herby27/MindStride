import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/widgets/screens/auth/login_screen.dart';
import 'auth_controller.dart';

///****************************************************************************
///MATTHEW H 2024
///This file manages the deletion of user data, intergfacing with Firebase to exute this task
///****************************************************************************

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    update();
  }

  deleteProfile() async {
    Get.dialog(AlertDialog(
      title: const Text("Alert!!"),
      content: const Text(
          "Sorry to see you go! Are you sure you want to delete your account?"),
      actions: [
        MaterialButton(
          child: const Text("No"),
          onPressed: () {
            Get.back();
          },
        ),
        MaterialButton(
          color: Colors.blue,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Get.back();
            await deleteUserData();
            Get.offAll(() => LoginScreen());
          },
        ),
      ],
    ));
  }

  deleteUserData() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    FirebaseAuth.instance.currentUser!.delete();
    AuthController.instance.signOut(); // Ensure user is signed out after deletion
  }
}
