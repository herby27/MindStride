import 'package:flutter/material.dart';
import 'package:mind_stride/views/widgets/screens/auth/login_screen.dart';
import 'package:mind_stride/views/widgets/screens/search_screen.dart';
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
    isAdmin = await Pref.getPrefValue("Role") == "0";
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
      icon: Icon(Icons.home, size: 30),
      label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search, size: 30),
        label: 'Search',
      ),
    ];
    bottomNavBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark, size: 30),
        label: 'Bookmarked Videos',
      ),
    );
    if (isAdmin) {
      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded, size: 30),
          label: 'Add Videos',
        ),
      );
    }
    bottomNavBarItems.add(
      const BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 30),
        label: 'Profile',
      ),
    );

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
        onTap: (index)
        {
          setState(() {
            pageIndex = index;
          });
        },
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.white,
    currentIndex: pageIndex,
    items: bottomNavBarItems,
    ),

    body: isAdmin
    ? [
    const ForYouVideoScreen(),
    SearchScreen(),
    const BookmarkVideoScreen(),
    const AddVideoScreen(),
    ProfileScreen(uid: AuthController.instance.user.uid),
    ][pageIndex]

    : [
    const ForYouVideoScreen(),
    SearchScreen(),
    const BookmarkVideoScreen(),
    ProfileScreen(uid: AuthController.instance.user.uid),
    ][pageIndex],
    );
  }
}