import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_stride/controllers/bookmarkVideo_controller.dart';
import 'package:mind_stride/views/widgets/video_player_item.dart'; // Ensure this is the correct path for your VideoPlayerItem widget

class BookmarkVideoScreen extends StatelessWidget {
  final BookmarkVideoController bookmarkVideoController = Get.put(BookmarkVideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Videos"),
      ),
      body: Obx(() {
        print("Attempting to display ${bookmarkVideoController.videoList.length} videos"); // Debug
        if (bookmarkVideoController.videoList.isEmpty) {
          return Center(child: Text("No bookmarked videos"));
        }
        return ListView.builder(
          itemCount: bookmarkVideoController.videoList.length,
          itemBuilder: (context, index) {
            final video = bookmarkVideoController.videoList[index];
            return ListTile(
              leading: VideoPlayerItem(videoUrl: video.videoUrl),
              title: Text(video.username),
              subtitle: Text(video.caption),
            );
          },
        );
      }),
    );

  }
}
