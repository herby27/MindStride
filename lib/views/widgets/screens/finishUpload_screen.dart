import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../../controllers/upload_controller.dart';

class FinishUploadScreen extends StatefulWidget {
  final String videoUrl;

  FinishUploadScreen({required this.videoUrl});

  @override
  State<FinishUploadScreen> createState() => _FinishUploadScreenState();
}

class _FinishUploadScreenState extends State<FinishUploadScreen> {
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  void initializeVideoPlayer() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController!,
            aspectRatio: 16 / 9,
            autoInitialize: true,
            looping: true,
            autoPlay: true,
          );
        });
      });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UploadController uploadController = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Finish Upload')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (chewieController != null)
              Chewie(controller: chewieController!),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  labelText: "Caption",
                  prefixIcon: Icon(Icons.slideshow_sharp),
                  labelStyle: const TextStyle(fontSize: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                uploadController.finalizeUpload(captionController.text);
              },
              child: const Text(
                'Post',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
