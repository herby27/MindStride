import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl);
    await videoPlayerController.initialize();
    if (mounted) {
      setState(() {
        videoPlayerController.play();
        videoPlayerController.setVolume(1.0);
        videoPlayerController.setLooping(true);
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized
        ? AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: CachedVideoPlayer(videoPlayerController),
    )
        : Container(
      width: 100, // Adjust according to your ListTile leading space
      height: 56, // Keeping a 16:9 aspect ratio
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
