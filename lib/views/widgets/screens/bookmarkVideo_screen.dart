import 'package:flutter/material.dart';

class BookmarkVideoScreen extends StatefulWidget {
  const BookmarkVideoScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkVideoScreen> createState() => _BookmarkVideoScreenState();
}

class _BookmarkVideoScreenState extends State<BookmarkVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bookmark Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}