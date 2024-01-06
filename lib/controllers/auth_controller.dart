import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mind_stride/models/user.dart' as model;
import 'package:mind_stride/views/widgets/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../app_pref.dart';
import '../models/user.dart';
import '../views/widgets/screens/auth/login_screen.dart';

///****************************************************************************
/// MATTHEW HERBERT 2024
///This file defines an AuthController class that manages authentication tasks
/// is responsible for:
///  -managing user authentication
///  -user data storage and interactions with Firebase services (eg. Firebase Authentication and Firestore).
/// ****************************************************************************

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  User get user => FirebaseAuth.instance.currentUser!; ///this defines an accessor method that retrieves the current user from Firebase Authentication

  @override
  void onReady() {
    ///When an instance of AuthController is created and attached to a GetX widget, the onReady method is called after the widget's rendering is complete.
    super
        .onReady(); ///This call ensures that any setup that's defined in the GetXController (which is the base class for all GetX controllers) are exexuted

    initializeScreen();
  }

  initializeScreen(){
    if (FirebaseAuth.instance.currentUser == null){ ///checks if no user is currently logged in
      Get.offAll(() => LoginScreen()); ///if there's no user logged in, navigates to the login screen
    } else {
      Get.offAll(() => HomeScreen()); ///if there is a user logged in, navigates to the home screen
    }
  }

  ///This function retrieves an instance of SharedPreferences and then uses it to store the string value under a specific key
  ///The data will remain constant throughout app restarts, with the data being stored under the same key
  //Future<void> setPrefValue(String key, String value) async { ///The setPref function returns a Future that takes two parameters (key and value) and completes w/ no value
    ///Key is the identifier for the stored data and value is the data
    //final SharedPreferences prefs = await SharedPreferences.getInstance(); ///The var prefs to hold the instance of SharedPreferences
    //await prefs.setString(key, value);
  //}

  ///This function stores a new user's data in the firestore database.
  void registerNewUser(
      String userName, String userEmail, String userPassword) async
  {
    try
    {
      if (userName.isNotEmpty && userEmail.isNotEmpty && userPassword.isNotEmpty) { ///Here we're checking to see if all of the required fields are filled
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword( ///Create a new user in Firebase Authentication
          email: userEmail,
          password: userPassword,
        );

        model.MindStrideUser user = model.MindStrideUser( ///Creates a MindStrideUser model object with the user's data
          name: userName,
          email: userEmail,
          role: 1, ///The default role for a regular user is set to 1
          uid: credential.user!.uid,
        );

        ///Here, we're storing the user data in the Firestore database under the 'users' collection
        await FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toJson());
        initializeScreen(); ///This navigates the user to the appropriate screen after a successful registration
      } else {
        ///This displays an error message if any of the required fields are not filled
        Get.snackbar('Error with account creation', 'All fields must be entered');
      }

    } on FirebaseAuthException catch (error)
    ///This handles any Firebase Authentication exceptions (eg. if the email address is already in use)
    {
      Get.snackbar(
        'Error with account creation',
        error.message.toString(),
      );
    }
  }

  getDataFromUser() async { ///retrieves user=specific data from the Firestore database
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(); ///the User ID serves as the key to retrieve the document for the logged-in user
    final userData = userDoc.data() ?? {} as dynamic; ///Data is extracted w/ the data() method; if there isn't any data, it defaults to an empty map
    int role1 = userData['role'] ?? 1; ///Looks for the role field in the userData map; if role field doesn't exist it defaults to 1
    ///Remember that regular user: role = 1; admin user: role = 0
    await Pref.setPrefValue("Role", role1.toString());

  }

  void loginUser(String userEmail, String userPassword) async
  {
    try
    {
      if (userEmail.isNotEmpty && userPassword.isNotEmpty)
      { ///Here we're checking to see if all of the required fields are filled
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      initializeScreen();
      }
      else
      {
        ///This displays an error message if any of the required fields are not filled
        Get.snackbar('Error with account creation', 'All fields must be entered');
      }

    } on FirebaseAuthException catch (error)
  ///This handles any Firebase Authentication exceptions (eg. if the email address is already in use)
      {
        Get.snackbar(
          'Error with account creation',
          error.message.toString(),
        );
      }
    }

  bool isAdminUser() {
    return Pref.getPrefValue("Role") == "0";
  }
  }