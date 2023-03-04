import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String userId;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.description,
    required this.username,
    required this.postId,
    required this.userId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "description": description,
        "postId": postId,
        "userId": userId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      username: snapshot["username"],
      postId: snapshot["postId"],
      userId: snapshot["userId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
    );
  }
}
