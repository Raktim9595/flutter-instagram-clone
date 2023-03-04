import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> navbarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_circle),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[800],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: homeScreenItems,
      items: navbarItems(),
      backgroundColor: mobileBackgroundColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
