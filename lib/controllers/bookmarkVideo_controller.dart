import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/video.dart';

///****************************************************************************
///MATTHEW H 2024
///This file manages fetching the list of videos bookmarked by the current user in real-time,
///and reacting to changes in the bookmarks collection for the user.
///****************************************************************************

class BookmarkVideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    subscribeToBookmarks();
  }

  void subscribeToBookmarks() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("User ID is null. User might not be logged in.");
      return;
    }
    // Listening to changes in real-time
    FirebaseFirestore.instance
        .collection('videos')
        .where('userIdThatBookmarked', arrayContains: uid)
        .snapshots()
        .listen((snapshot) {
      final bookmarks = snapshot.docs.map((doc) => Video.fromSnap(doc)).toList();
      _videoList.value = bookmarks;
      print("${bookmarks.length} bookmarked videos fetched for user ID: $uid");
    }).onError((error) {
      print("Error subscribing to bookmarked videos: $error");
    });
  }
}
