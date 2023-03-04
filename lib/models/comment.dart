class Comment {
  final String commentId;
  final String profilePic;
  final String username;
  final String commentText;
  final DateTime commentedAt;
  final String userId;
  final String postId;
  final likes;

  const Comment({
    required this.commentId,
    required this.profilePic,
    required this.username,
    required this.commentText,
    required this.commentedAt,
    required this.userId,
    required this.likes,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "profilePic": profilePic,
    "username": username,
    "commentText": commentText,
    "commentedAt": commentedAt,
    "userId": userId,
    "likes": likes,
    "postId": postId,
  };
}