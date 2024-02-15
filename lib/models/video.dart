import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String id; // Add this line
  String uid;
  String username;
  String thumbnail;
  String videoUrl;
  String caption;
  List<dynamic> userIdThatBookmarked;

  Video({
    required this.id, // Update constructor
    required this.uid,
    required this.username,
    required this.thumbnail,
    required this.videoUrl,
    required this.caption,
    required this.userIdThatBookmarked,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "thumbnail": thumbnail,
    "videoUrl": videoUrl,
    "caption": caption,
    "userIdThatBookmarked": userIdThatBookmarked,
  };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Video(
      id: snap.id, // Use document ID as video ID
      uid: snapshot['uid'] ?? '',
      username: snapshot['username'] ?? '',
      thumbnail: snapshot['thumbnail'] ?? '',
      videoUrl: snapshot['videoUrl'] ?? '',
      caption: snapshot['caption'] ?? '',
      userIdThatBookmarked: List.from(snapshot['userIdThatBookmarked'] ?? []),
    );
  }
}


