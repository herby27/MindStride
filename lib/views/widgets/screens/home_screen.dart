import 'package:flutter/material.dart';
import 'package:mind_stride/views/widgets/screens/auth/login_screen.dart';
import 'package:mind_stride/views/widgets/screens/for_you_video_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_pref.dart';
import '../../../controllers/auth_controller.dart';
import 'addVideo_screen.dart';
import 'auth/profile_screen.dart';
import 'bookmarkVideo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await AuthController.instance.getDataFromUser();
    isAdmin = Pref.getPrefValue("Role") == "0"; // Ensure this async call is awaited or handled correctly
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [
      ForYouVideoScreen(),
      BookmarkVideoScreen(), // Removed const
    ];

    if (isAdmin) {
      pageList.add(AddVideoScreen());
    }

    pageList.add(ProfileScreen(uid: AuthController.instance.user.uid));

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
          if (isAdmin) BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Add Videos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: IndexedStack(
        index: pageIndex,
        children: pageList,
      ),
    );
  }
}
