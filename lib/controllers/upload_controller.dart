import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mind_stride/models/video.dart';
import 'package:mind_stride/views/widgets/screens/home_screen.dart';
import '../views/widgets/screens/addVideo_screen.dart';
import '../views/widgets/screens/finishUpload_screen.dart';

///****************************************************************************
/// MATTHEW H 2024
///The UploadController class is responsible for handling the video upload process
///It manages the uploading of video and thumbnail files to Firebase storage
///It does this by creating a video object, reflecting Object Oriented Programming techniques
/// ****************************************************************************

class UploadController extends GetxController {
  ///These fields store the URLs or uploaded videos and thumbnails
  late String videoUrl;
  late String thumbnailUrl;
  ///These fields store the current user's ID and username
  late String uid;
  late String username;

  ///This is a method that uploads a file to Firebase Storage and returns the file URL
  Future<String> uploadFileToStorage(String path, Uint8List fileData, String fileName) async {
    ///Here we're creating reference to the Firebase Storage location where the file will be stored.
    Reference ref = FirebaseStorage.instance.ref().child(path).child(fileName);
    ///Here we're creating an upload task by calling the putData method on the storage reference ref
    UploadTask uploadTask = ref.putData(fileData);
    ///Once the upload is complete, it returns a TaskSnapshot
    TaskSnapshot snapshot = await uploadTask;
    ///
    return await snapshot.ref.getDownloadURL();
  }

  ///This is a method that handles the video and thumbnail uploading process
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
      // Use the generated videoID as the document ID and also pass it to the Video object
      String videoID = DateTime.now().millisecondsSinceEpoch.toString();

      // Include the 'id' field when creating the Video object
      Video videoObject = Video(
        id: videoID, // Add this line to include the id
        uid: uid,
        username: username,
        thumbnail: thumbnailUrl,
        videoUrl: videoUrl,
        caption: caption,
        userIdThatBookmarked: [],
      );

      // Use the videoID as the document ID when setting the video data
      await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());

      Get.snackbar("Success", "Video Posted Successfully");
      Get.offAll(() => HomeScreen());
    } catch (error) {
      print("Error uploading video: $error");
      Get.snackbar("Unsuccessful Video Upload", error.toString());
    }
  }

}


