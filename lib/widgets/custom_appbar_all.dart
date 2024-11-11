// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'badges.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';

enum FilterOptions { favourites, all }

// Your custom Cart and Badge classes should be defined here or imported as needed.

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height - 60, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  String title;
 final List<Widget>? actions;
  CustomAppBar2({required this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomAppBarClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 136, 116, 169),
              Color.fromARGB(255, 55, 25, 104),
              Color.fromARGB(255, 116, 72, 120),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          actions: actions,
      //     iconTheme: const IconThemeData(
      //   color: Colors.white, // Set the drawer icon color to white
      // ),
        ),
      ),
    );
  }
}
