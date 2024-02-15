import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import '../../../controllers/videoPlayer_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForYouVideoScreen extends StatefulWidget {
  const ForYouVideoScreen({Key? key}) : super(key: key);

  @override
  State<ForYouVideoScreen> createState() => _ForYouVideoScreenState();
}

class _ForYouVideoScreenState extends State<ForYouVideoScreen> {
  final VideoPlayerController videoController = Get.put(VideoPlayerController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (videoController.videoList.isEmpty) {
          return Center(child: Text("No videos available"));
        }
        if (_currentIndex >= videoController.videoList.length) {
          _currentIndex = 0;
        }
        final videoData = videoController.videoList[_currentIndex];
        final isBookmarked = videoData.userIdThatBookmarked.contains(_auth.currentUser!.uid);

        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    videoData.username,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: VideoPlayerWidget(
                      key: ValueKey(_currentIndex),
                      videoUrl: videoData.videoUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    videoData.caption,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                _buildVideoNavigationControls(),
              ],
            ),
            Positioned(
              left: 20, // Adjust as necessary for alignment
              top: MediaQuery.of(context).size.height / 2 - 20, // Center vertically relative to screen
              child: InkWell(
                onTap: () => videoController.toggleBookmark(videoData.id, _auth.currentUser!.uid),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 40,
                  color: isBookmarked ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildVideoNavigationControls() {
    // This widget is placed back at the bottom of the video
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _goToPreviousVideo,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: _goToNextVideo,
        ),
      ],
    );
  }

  void updateCurrentIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < videoController.videoList.length) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  void _goToNextVideo() {
    int nextIndex = _currentIndex + 1;
    if (nextIndex < videoController.videoList.length) {
      updateCurrentIndex(nextIndex);
    }
  }

  void _goToPreviousVideo() {
    int prevIndex = _currentIndex - 1;
    if (prevIndex >= 0) {
      updateCurrentIndex(prevIndex);
    }
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
        _controller.setLooping(true);
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
    if (_controller.value.isInitialized) {
      final aspectRatio = _controller.value.aspectRatio;
      final videoWidth = MediaQuery.of(context).size.width / 1.5;

      return Center(
        child: Container(
          width: videoWidth,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: vp.VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
