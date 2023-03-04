import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
// import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FeedProfileScreen extends StatefulWidget {
  const FeedProfileScreen({
    super.key,
  });

  @override
  State<FeedProfileScreen> createState() => _FeedProfileScreenState();
}

class _FeedProfileScreenState extends State<FeedProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (
        context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapUser,
      ) {
        if (snapUser.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Text(snapUser.data!["username"]),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("userId", isEqualTo: _auth.currentUser!.uid)
                .snapshots(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshotPost,
            ) {
              if (snapshotPost.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(snapUser.data!["photoUrl"]),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      buildStatColumn(
                                          snapshotPost.data!.docs.length,
                                          "posts"),
                                      buildStatColumn(
                                          snapUser.data!["followers"].length,
                                          "followers"),
                                      buildStatColumn(
                                          snapUser.data!["following"].length,
                                          "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FollowButton(
                                        function: () async {
                                          await AuthMethods().signOut();
                                          if (context.mounted) {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: const LoginScreen(),
                                              withNavBar: false,
                                            );
                                          }
                                        },
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        text: "Sign Out",
                                        textColor: primaryColor,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            snapUser.data!["username"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(snapUser.data!["bio"]),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshotPost.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshotPost.data!.docs[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(snap["postUrl"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
