import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap["profilePic"]),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "  ${widget.snap['commentText']}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: DateFormat.yMMMd().format(
                            widget.snap["commentedAt"].toDate(),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[300],
                          ),
                        ),
                        TextSpan(
                          text: widget.snap["likes"].isNotEmpty
                              ? "  ${widget.snap['likes'].length} likes"
                              : "",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[300],
                          ),
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () async {
                await FirestoreMethods().likeComment(
                  widget.snap["commentId"],
                  widget.snap["userId"],
                  widget.snap["likes"],
                  widget.snap["postId"],
                );
              },
              icon: widget.snap["likes"].contains(widget.snap["userId"])
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_outline),
            ),
          )
        ],
      ),
    );
  }
}
