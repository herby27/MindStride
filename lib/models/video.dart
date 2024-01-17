import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String uid;
  String username;
  String thumbnail;
  String videoUrl;
  String caption;

  Video({
    required this.uid,
    required this.username,
    required this.thumbnail,
    required this.videoUrl,
    required this.caption,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "thumbnail": thumbnail,
    "videoUrl": videoUrl,
    "caption": caption,
  };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      uid: snapshot['uid'] ?? '',
      username: snapshot['username'] ?? '',
      thumbnail: snapshot['thumbnail'] ?? '',
      videoUrl: snapshot['videoUrl'] ?? '',
      caption: snapshot['caption'] ?? '',
    );
  }
}

