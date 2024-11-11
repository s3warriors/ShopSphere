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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(FilterOptions) onSelected;
  final bool showFavoritesOnly;

  CustomAppBar({required this.onSelected, required this.showFavoritesOnly});

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
      //     iconTheme: const IconThemeData(
      //   color: Colors.white, // Set the drawer icon color to white
      // ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'MyShop',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: FilterOptions.favourites,
                  child: Text('Only Favourites'),
                ),
                PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show All'),
                ),
              ],
              onSelected: (FilterOptions selectedVal) {
                onSelected(selectedVal);
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) {
                return badge(
                  value: cart.ItemCount.toString(),
                  passedchild: ch ?? Container(),
                );
              },
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
