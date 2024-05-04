import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFF003366),
      color: Colors.blue[100],
      child: Stack(
        children: [
          Positioned(
            top: 160.0, // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              'assets/network.jpg',
             //Replace with your image path
              height: 200.0, // Adjust the height as needed
            ),
          ),
          Positioned(
            bottom: 200.0, // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                Text(
                  'NETWORK SOCIALLY',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '  Join groups based on your interests for socializing and networking.',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}