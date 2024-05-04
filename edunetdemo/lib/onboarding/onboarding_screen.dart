// import 'package:flutter/cupertino.dart';
import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/onboarding/intro_screens/intro_page_1.dart';
import 'package:edunetdemo/onboarding/intro_screens/intro_page_2.dart';
import 'package:edunetdemo/onboarding/intro_screens/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:flutter/widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //controller to keep track of which page we're on
  PageController _controller = PageController();

  //keep track of if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          //dot indicators
          Container(
              alignment: Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                        color: Colors.black, // Set the text color to white
                      ),
                    ),
                  ),

                  //dot indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    // effect: ExpandingDotsEffect(
                    //       activeDotColor: Colors.white, // Active dot color
                    //       dotColor: Colors.white.withOpacity(0.5), // Inactive dot color
                    //       // dotHeight: 12, // Height of the dots
                    //       // dotWidth: 12, // Width of the dots
                    //       // spacing: 8, // Spacing between dots
                    //     ),
                  ),

                  //next or done
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MainPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'DONE',
                            style: TextStyle(
                              color:
                                  Colors.black, // Set the text color to white
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              color:
                                  Colors.black, // Set the text color to white
                            ),
                          ),
                        ),
                ],
              ))
        ],
      ),
    );
  }
}
