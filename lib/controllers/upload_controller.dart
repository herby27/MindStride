import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mind_stride/models/video.dart';
import 'package:mind_stride/views/widgets/screens/home_screen.dart';

import '../views/widgets/screens/addVideo_screen.dart';
import '../views/widgets/screens/finishUpload_screen.dart';

class UploadController extends GetxController {
  late String videoUrl;
  late String thumbnailUrl;
  late String uid;
  late String username;

  Future<String> uploadFileToStorage(String path, Uint8List fileData, String fileName) async {
    Reference ref = FirebaseStorage.instance.ref().child(path).child(fileName);
    UploadTask uploadTask = ref.putData(fileData);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveVideo(Uint8List videoBytes, String videoFileName, Uint8List thumbnailBytes, String thumbnailFileName) async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    username = (userDocumentSnapshot.data() as Map<String, dynamic>)["name"];

    videoUrl = await uploadFileToStorage('videos', videoBytes, videoFileName);
    thumbnailUrl = await uploadFileToStorage('thumbnails', thumbnailBytes, thumbnailFileName);

    // Navigate to FinishUploadScreen with the video and thumbnail URLs
    Get.to(() => FinishUploadScreen(videoUrl: videoUrl));
  }

  void finalizeUpload(String caption) async {
    try {
      String videoID = DateTime.now().millisecondsSinceEpoch.toString();

      Video videoObject = Video(
        uid: uid,
        username: username,
        thumbnail: thumbnailUrl,
        videoUrl: videoUrl,
        caption: caption,
      );

      await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());

      Get.snackbar("Success", "Video Posted Successfully");
      Get.offAll(() => HomeScreen());
    } catch (error) {
      print("Error uploading video: $error");
      Get.snackbar("Unsuccessful Video Upload", error.toString());
    }
  }
}


