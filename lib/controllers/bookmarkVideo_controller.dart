import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/video.dart';

class BookmarkVideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    getBookmarkVideos();
  }

  void getBookmarkVideos() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("Fetching bookmarked videos for user: $uid"); // Debug statement
    try {
      List<Video> bookmarks = [];
      var bookmarkSnapshot = await FirebaseFirestore.instance
          .collection('users').doc(uid)
          .collection('bookmarkVideos').get();

      print("Found ${bookmarkSnapshot.docs.length} bookmarked items"); // Debug

      for (var bookmarkDoc in bookmarkSnapshot.docs) {
        var videoDoc = await FirebaseFirestore.instance
            .collection('videos').doc(bookmarkDoc.id).get();

        if (videoDoc.exists) {
          print("Adding video: ${videoDoc.id} to bookmarks"); // Debug
          bookmarks.add(Video.fromSnap(videoDoc));
        }
      }
      _videoList.value = bookmarks;
    } catch (e) {
      print("Error fetching bookmarked videos: $e"); // Error handling
    }
  }

}

