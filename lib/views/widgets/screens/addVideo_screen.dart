import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../controllers/upload_controller.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  Future<void> pickVideoAndThumbnail(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select an mp4 video (16:9 aspect ratio)')),
    );

    FilePickerResult? videoResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (videoResult != null) {
      Uint8List videoBytes = videoResult.files.first.bytes!;
      String videoFileName = videoResult.files.first.name;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'Please select a jpg, jpeg, or png thumbnail image (16:9 aspect ratio)')),
      );

      FilePickerResult? imageResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (imageResult != null) {
        Uint8List thumbnailBytes = imageResult.files.first.bytes!;
        String thumbnailFileName = imageResult.files.first.name;

        UploadController uploadController = Get.find<UploadController>();
        await uploadController.saveVideo(
            videoBytes, videoFileName, thumbnailBytes, thumbnailFileName);
      }
    }
  }



  void showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideoAndThumbnail(context),
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
                  color: Colors.white,
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
