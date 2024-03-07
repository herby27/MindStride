import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video.dart';

///****************************************************************************
/// MATTHEW H 2024
/// The VideoPlayerController class manages the fetching, display, and bookmarking functionality
/// of videos within the application.
/// This class interfaces with Firebase Firestore to retrieve video data.
/// ****************************************************************************

class VideoPlayerController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Video> retVal = [];
        for (var element in query.docs) {
          final video = Video.fromSnap(element);
          print("Video from Firestore: ${video.videoUrl}"); // Debug print
          retVal.add(video);
        }
        print("Total videos fetched: ${retVal.length}"); // Debug print
        return retVal;
      }),
    );
  }

  Future<void> toggleBookmark(String videoId, String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('videos').doc(videoId).get();

    if ((doc.data() as dynamic)['userIdThatBookmarked'].contains(userId)) {
      await FirebaseFirestore.instance.collection('videos').doc(videoId).update({
        'userIdThatBookmarked': FieldValue.arrayRemove([userId])
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(videoId).update({
        'userIdThatBookmarked': FieldValue.arrayUnion([userId])
      });
    }
  }

}
