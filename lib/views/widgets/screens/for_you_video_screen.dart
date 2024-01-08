import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp; // Alias for video_player package
import '../../../controllers/videoPlayer_controller.dart';

class ForYouVideoScreen extends StatefulWidget {
  const ForYouVideoScreen({Key? key}) : super(key: key);

  @override
  State<ForYouVideoScreen> createState() => _ForYouVideoScreenState();
}

class _ForYouVideoScreenState extends State<ForYouVideoScreen> {
  final VideoPlayerController videoController = Get.put(VideoPlayerController());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (videoController.videoList.isEmpty) {
          // Display a placeholder or message when the list is empty
          return Center(child: Text("No videos available"));
        }

        final videoData = videoController.videoList[_currentIndex];
        return Stack(
            children: [
              VideoPlayerWidget(videoUrl: videoData.videoUrl),
                Column(
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Text(
                              "@" + videoData.username.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              videoData.caption.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        )
                      ),
          )

                  ],

          )

              ]
          );
        }),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late vp.VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = vp.VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: vp.VideoPlayer(_controller),
    )
        : Center(child: Text("Loading..."));
  }
}