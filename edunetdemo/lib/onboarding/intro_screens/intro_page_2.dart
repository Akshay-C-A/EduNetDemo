import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFF003366),
      color: Colors.orangeAccent[100],

      child: Stack(
        children: [
          Positioned(
            top: 160.0, // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              'assets/event.jpg',
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
                  'MANAGE EVENTS',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '  Effortlessly create and organize events tailored to your needs.',
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