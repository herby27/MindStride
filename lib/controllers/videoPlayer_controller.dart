import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video.dart';

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
          retVal.add(Video.fromSnap(element));
        }
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
