import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_stride/views/widgets/screens/auth/login_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/upload_controller.dart'; // Import UploadController

///****************************************************************************
/// MATTHEW HERBERT 2024
/// This file is the main entry point of the MindStride flutter application
/// This code sets up the MindStride app with Firebase initialization,
/// uses the get package for state management,
/// and defines the app's entry point and initial screen as the login screen.
///****************************************************************************

///The main function initializes firebase and the AuthController and runs the MyApp widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDFs2V4avVeWl0NLzJUughSLa1_3_cFWPQ",
      appId: "1:366282284454:web:0cf9e4790672021f05c367",
      messagingSenderId: "366282284454",
      projectId: "mindstride-4cfc3",
      storageBucket: "mindstride-4cfc3.appspot.com", // Ensure this matches your Firebase Console
    ),
  ).then((value) {
    Get.put(AuthController()); // Initialize AuthController
    Get.put(UploadController()); // Initialize UploadController globally
  });
  runApp(const MyApp());
}

///The MyApp function defines the MyApp widget, which is the top-level widget that defines the overall structure of the app (eg. title, theme, etc)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ///The build function creates a GetMaterialApp widget, which is a configuration widget within MyApp
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MindStride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoginScreen(),
    );
  }
}
