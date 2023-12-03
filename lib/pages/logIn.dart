import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reservation/pages/register.dart';
import 'package:reservation/pages/reservation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  //firebase
  final _auth = FirebaseAuth.instance;
  //form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  maxLines: 1,
                  validator: (value)
                  {
                    if(value!.isEmpty)
                    {
                      return('Email field is required');
                    }
                    //regEx for email
                    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)){return("Please Enter a valid  email");}
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration:  InputDecoration(

                      labelText: 'Password'),
                  validator: (value)
                  {
                    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!$@#&*~]).{6,}$');
                    if(value!.isEmpty)
                    {
                      return('Password field cannot be null');
                    }
                    //regEx for password field
                    if(!regex.hasMatch(value)){
                      return ('Password should: \n'
                          ' Have at least 6 characters\n '
                          'Have a symbol \n'
                          'Have an uppercase \n'
                          'Have a numeric number \n'
                          'eg. Reserve@1');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement login logic here
                    // Navigate to the reservation screen upon successful login
                    signIn(_emailController.text, _passwordController.text);
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReservationScreen(),
                      ),
                    );
                  },
                  child: const Text('LOG IN AS GUEST'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to the registration screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text('Don\'t have an account? Register here.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Perform sign-in
        var userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        setState(() {
          isLoading = false;
        });

        // Navigate to home screen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ReservationScreen()));

        // Show success message
        Fluttertoast.showToast(
          msg: 'Login Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          fontSize: 16,
        );
      } catch (e) {
        log(e.toString());

        setState(() {
          isLoading = false;
        });

        // Show error message
        String errorMessage = 'An error occurred during sign-in.';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              errorMessage = 'Invalid email address.';
              break;
            case 'user-not-found':
              errorMessage = 'User not found. Please check your credentials.';
              break;
            case 'wrong-password':
              errorMessage =
                  'Invalid password. Please check your password and try again.';
              break;
            // Add more cases for other possible error codes
            default:
              errorMessage =
                  'An error occurred during sign-in. Please try again later.';
          }
        }
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          fontSize: 16,
        );
      }
    }
  }
}
