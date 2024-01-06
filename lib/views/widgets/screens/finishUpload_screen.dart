import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_video_player/cached_video_player.dart';
import '../../../controllers/upload_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

class FinishUploadScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  FinishUploadScreen({required this.videoFile, required this.videoPath});

  @override
  State<FinishUploadScreen> createState() => _FinishUploadScreenState();
}

class _FinishUploadScreenState extends State<FinishUploadScreen> {
  UploadController uploadVideoController = Get.put(UploadController());
  ChewieController? chewieController;
  TextEditingController descriptionTagsTextEditingController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    // Use different logic for web and other platforms
    if (!kIsWeb) {
      chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.file(widget.videoFile),
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: true,
        autoPlay: true,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display video player
            if (!kIsWeb && chewieController != null)
              Chewie(controller: chewieController!),

            const SizedBox(
              height: 30,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: descriptionTagsTextEditingController,
                decoration: InputDecoration(
                  labelText: "Caption",
                  prefixIcon: Icon(Icons.slideshow_sharp),
                  labelStyle: const TextStyle(
                    fontSize: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 38,
              height: 54,
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
