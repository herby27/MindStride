import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mind_stride/models/video.dart';

import '../views/widgets/screens/finishUpload_screen.dart';

class UploadController extends GetxController {
  late String videoUrl;
  late String thumbnailUrl;

  Future<String> uploadFileToStorage(String path, Uint8List fileData, String fileName) async {
    Reference ref = FirebaseStorage.instance.ref().child(path).child(fileName);
    UploadTask uploadTask = ref.putData(fileData);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveVideo(String caption, Uint8List videoBytes, String videoFileName, Uint8List thumbnailBytes, String thumbnailFileName) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    String videoID = DateTime.now().millisecondsSinceEpoch.toString();

    videoUrl = await uploadFileToStorage('videos', videoBytes, videoFileName);
    thumbnailUrl = await uploadFileToStorage('thumbnails', thumbnailBytes, thumbnailFileName);

    Video videoObject = Video(
      uid: uid,
      username: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
      userIdThatBookmarked: [],
      videoID: videoID,
      caption: caption,
      videoUrl: videoUrl,
      thumbnail: thumbnailUrl,
    );

    await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());

    Get.to(() => FinishUploadScreen(videoUrl: videoUrl));
  }

  void finalizeUpload(String caption) async {
    try {
      await FirebaseFirestore.instance.collection("videos").add({
        'caption': caption,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        // Add other video details if needed
      });
      Get.snackbar("Success", "Video Posted Successfully");
    } catch (error) {


      print("Error uploading video: $error");
      Get.snackbar("Unsuccessful Video Upload", error.toString());
    }
  }
}
