
import 'package:flutter/material.dart';

// class IntroPage1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.pink[100],
//       child: Center(
//         child: Text(
//           '"Connect Alumni"\n\n Find and connect with former classmates and professionals easily.',
//           style: TextStyle(
//             fontSize: 24.0,
//             color: Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFF003366),
      color: Colors.yellow[200],

      child: Stack(
        children: [
           Positioned(
            top: 160.0, // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            child:Image.asset(
              'assets/alumni.jpg',
             //Replace with your image path
              height: 170.0,
               // Adjust the height as needed
            ),
            
          ),
          Positioned(
            bottom: 200.0, // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                Text(
                  'CONNECT ALUMNI',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '  Find and connect with former classmates and professionals easily.',
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