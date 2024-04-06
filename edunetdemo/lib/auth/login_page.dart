import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: ${e.message}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Padding(
  //       padding: EdgeInsets.all(40.0),

  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,

  //         children: [
  //           Text(
  //             'Log In',
  //             style: TextStyle(
  //               color: Colors.blueAccent,
  //               fontSize: 30.0,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),

  //           SizedBox(height: 20.0),

  //           TextField(
  //             controller: emailController,
  //             decoration: InputDecoration(
  //               labelText: 'Email',
  //             ),
  //           ),

  //           SizedBox(height: 20.0),

  //           TextField(
  //             controller: passwordController,
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               labelText: 'Password',
  //             ),
  //           ),

  //           SizedBox(height: 20.0),
  
  //           if (_isLoading)
  //             CircularProgressIndicator()
  //           else
  //             ElevatedButton(
  //               onPressed: () {
  //                 signIn();
  //               },
  //               child: Text('Log In'),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 // Adding space between the top and the 'Login' heading
                Text(
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0, // Slightly larger font size
                    fontWeight: FontWeight.bold, // Bold font weight
                  ),
                ),

                SizedBox(height: 10.0),

                TextField(
                  // controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email id',
                  ),
                ),

                SizedBox(height: 20.0),

                TextField(
                  // controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),

                SizedBox(height: 20.0),

                if (_isLoading)
                  CircularProgressIndicator()
                else
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}