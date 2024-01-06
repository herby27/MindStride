import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mind_stride/models/video.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

class UploadController extends GetxController{
  compressVideo(String videoFilePath) async{
    final compressedVideo = await VideoCompress.compressVideo(
        videoFilePath,
        quality: VideoQuality.HighestQuality,
        includeAudio: true,
    );
    return compressedVideo?.file;
  }
  Future<String> uploadCompressedVideoFileToStorage(String videoID, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child('videos').child(videoID);
    UploadTask videoUploadTask = ref.putFile(await compressVideo(videoPath));
    TaskSnapshot snapshot = await videoUploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadThumbnailToStorage(String videoID, String videoPath) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('thumbnails').child(videoID);
    UploadTask thumbnailUploadTask = storageRef.putFile(await getThumbnail(videoPath));
    TaskSnapshot snapshot = await thumbnailUploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  getThumbnail(String videoPath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<void> saveVideo(String caption, String videoPath) async {
    print("saveVideo function has been called!");
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      String videoID = DateTime.now().millisecondsSinceEpoch.toString();

      // Compress video
      File? compressedVideo = await compressVideo(videoPath);

      if (compressedVideo == null) {
        Get.snackbar("Unsuccessful Video Upload", "Video compression failed.");
        return;
      }

      List<String> urls = await Future.wait([
        uploadCompressedVideoFileToStorage(videoID, compressedVideo.path),
        uploadThumbnailToStorage(videoID, compressedVideo.path),
      ]);

      print("Original Video Path: $videoPath");
      print("Compressed Video Path: ${compressedVideo.path}");
      print("Thumbnail Path: ${compressedVideo.path}");

      String videoDownloadUrl = urls[0];
      String thumbnailDownloadUrl = urls[1];

      Video videoObject = Video(
        uid: uid,
        username: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        userIdThatBookmarked: [],
        videoID: videoID,
        caption: caption,
        videoUrl: videoDownloadUrl,
        thumbnail: thumbnailDownloadUrl,
      );

      await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());

      Get.snackbar("New Video", "You have successfully uploaded your new video");
      Get.back();

    } catch (error) {
      print(error);
      Get.snackbar("Unsuccessful Video Upload", "Try Again.");
    }
  }

}
