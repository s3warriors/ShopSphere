// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:myshop/screens/auth_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after a delay of 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      // Ensure the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  AuthScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
                Color.fromARGB(255, 136, 116, 169),
              Color.fromARGB(255, 55, 25, 104),
              // Color.fromARGB(255, 49, 101, 132),
              // Color.fromARGB(255, 165, 56, 46),
              Color.fromARGB(255, 246, 246, 245),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_outlined, // Financial icon for FinLog
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'MyShop',
                style: TextStyle(
                  letterSpacing: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Shop Smart, Shop Simple',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              'MyShop, Your One-Stop Store!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 19,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

