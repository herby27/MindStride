import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:mind_stride/controllers/bookmarkVideo_controller.dart';

class BookmarkVideoScreen extends StatefulWidget {
  const BookmarkVideoScreen({Key? key}) : super(key: key);

  @override
  _BookmarkVideoScreenState createState() => _BookmarkVideoScreenState();
}

class _BookmarkVideoScreenState extends State<BookmarkVideoScreen> {
  final BookmarkVideoController bookmarkVideoController = Get.find<BookmarkVideoController>();
  PageController _pageController = PageController(); // Added for PageView control

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        bookmarkVideoController.subscribeToBookmarks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Videos"),
      ),
      body: Obx(() {
        if (bookmarkVideoController.videoList.isEmpty) {
          return Center(child: Text("No bookmarked videos"));
        }
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController, // Use the PageController here
                itemCount: bookmarkVideoController.videoList.length,
                itemBuilder: (context, index) {
                  final videoData = bookmarkVideoController.videoList[index];
                  return Column(
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
                            key: ValueKey(videoData.id),
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
                    ],
                  );
                },
              ),
            ),
            _buildVideoNavigationControls(), // Call the method to build navigation controls
          ],
        );
      }),
    );
  }

  Widget _buildVideoNavigationControls() {
    // Build the navigation arrows below the video
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
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
        _controller.setLooping(true);
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
        : Center(child: CircularProgressIndicator());
  }
}
