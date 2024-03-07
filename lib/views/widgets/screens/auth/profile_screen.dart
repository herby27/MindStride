import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_stride/controllers/profile_controller.dart';
import '../../../../controllers/auth_controller.dart';

///****************************************************************************
///MATTHEW H 2024
///This file controls the UI for the profile screen.
///It includes a sign out functionality and an account deletion functionality
///****************************************************************************

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            title: Text(
              controller.user.isNotEmpty ? controller.user['name'] : 'Profile',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sign Out Button
                  ElevatedButton(
                    onPressed: () {
                      if (widget.uid == AuthController.instance.user.uid) {
                        AuthController.instance.signOut();
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                  const SizedBox(height: 20),
                  // Delete Account Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      if (widget.uid == AuthController.instance.user.uid) {
                        profileController.deleteProfile();
                      }
                    },
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
