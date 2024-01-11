import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:mind_stride/controllers/upload_controller.dart';
import '../models/video.dart';

class VideoPlayerController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  Rx<int> role = 1.obs;

  @override
  void onInit() {
    super.onInit();

    print("_videoList.bindStream() called!");

    _videoList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          //.orderBy("videoID", descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<Video> retVal = [];
        for (var element in query.docs) {
          retVal.add(Video.fromSnap(element));
        }

        print("Retrieved ${retVal.length} videos");

        return retVal;
      }),
    );

    /*deleteVideo(String id, int index) async {
      try {
        Reference refVid = FirebaseStorage.instance.ref().child('videos').child(
            id);
        refVid.delete();
        Reference refThumb = FirebaseStorage.instance.ref()
            .child('thumbnails')
            .child(id);
        refThumb.delete();
        await FirebaseFirestore.instance.collection('videos').doc(id).delete();

        _videoList.refresh();
        Get.snackbar(
          'Deleted',
          'Video Deleted Successfully',
        );

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users').get();
        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (QueryDocumentSnapshot userSnapshot in querySnapshot.docs) {
          DocumentReference bookmarkVideoDocRef = FirebaseFirestore.instance
              .collection('users')
              .doc(userSnapshot.id)
              .collection('bookmarkVideos')
              .doc(id);

          batch.delete(bookmarkVideoDocRef);
        }

        await batch.commit();
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
        );
      }
    } */

    /*bookmarkVideo(String id) async {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(
          'videos').doc(id).get();
      var uid = FirebaseAuth.instance.currentUser!.uid;
      if ((doc.data()! as dynamic)['userIdThatBookmarked'].contains(uid)) {
        await FirebaseFirestore.instance.collection('videos').doc(id).update({
          'userIdThatBookmarked': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance.collection('videos').doc(id).update({
          'userIdThatBookmarked': FieldValue.arrayUnion([uid])
        });
      }
      DocumentSnapshot bookmarkVideoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('bookmarkVideos')
          .doc(id)
          .get();

      if (!bookmarkVideoSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('bookmarkVideos')
            .doc(id)
            .set({});
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('bookmarkVideos')
            .doc(id)
            .delete();
      }
    }

     */
  }
}