import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Video Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}