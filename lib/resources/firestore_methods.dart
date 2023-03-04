import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:uuid/uuid.dart';

import './storage_methods.dart';
import '../models/comment.dart' as model;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String postId = const Uuid().v1();

  Future<String> uploadPost(
    String userId,
    String description,
    Uint8List file,
    String username,
    String profileImage,
  ) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      Post post = Post(
        description: description,
        username: username,
        postId: postId,
        userId: userId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String userId, List likes) async {
    try {
      if (likes.contains(userId)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([userId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likeComment(
      String commentId, String userId, List likes, String postId) async {
    try {
      if (likes.contains(userId)) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([userId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> postComments(
    String postId,
    String text,
    String userId,
    String username,
    String profilePic,
  ) async {
    var res = "Something went wrong";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        model.Comment comment = model.Comment(
          username: username,
          userId: userId,
          commentText: text,
          profilePic: profilePic,
          commentId: commentId,
          commentedAt: DateTime.now(),
          likes: [],
          postId: postId,
        );

        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(comment.toJson());

        res = "success";
      } else {
        res = "please enter some comment";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // deleting the post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  // follow functionality
  Future<void> followUser(
    String currentUserUid,
    String followUserUid,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(currentUserUid).get();
      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followUserUid)) {
        await _firestore.collection("users").doc(followUserUid).update({
          "followers": FieldValue.arrayRemove([currentUserUid])
        });
        await _firestore.collection("users").doc(currentUserUid).update({
          "following": FieldValue.arrayRemove([followUserUid])
        });
      } else {
        await _firestore.collection("users").doc(followUserUid).update({
          "followers": FieldValue.arrayUnion([currentUserUid])
        });
        await _firestore.collection("users").doc(currentUserUid).update({
          "following": FieldValue.arrayUnion([followUserUid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
