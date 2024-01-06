import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:mind_stride/views/widgets/screens/finishUpload_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../controllers/upload_controller.dart';


class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(BuildContext context) async {
    print("pickVideo function has been called!");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      File videoFile;

      if (kIsWeb) {
        // For web, use bytes property
        videoFile = File.fromRawPath(result.files.first.bytes!);
      } else {
        // For other platforms, use path property
        videoFile = File(result.files.first.path!);
      }

      UploadController uploadController = Get.put(
        UploadController(),
        tag: videoFile.path, // Unique tag for each file
      );

      await uploadController.saveVideo('YourCaption', videoFile.path);

      Get.to(
            () => FinishUploadScreen(
          videoFile: videoFile,
          videoPath: videoFile.path,
        ),
      );
    }
  }


  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(context),
            child: Row(
              children: const [
                Icon(Icons.file_upload),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Upload Video',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: Colors.blue),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}