import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_profile_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreensize = 600;

TextStyle optionStyle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey[200]);

List<Widget> homeScreenItems = <Widget>[
 const FeedScreen(),
 const SearchScreen(),
  const AddPostScreen(),
  Scaffold(
    body: Center(
      child: Text(
        'Index 3: Home',
        style: optionStyle,
      ),
    ),
  ),
  const FeedProfileScreen(),
];
