// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_firebase_authentication/screens/email_auth/signup.dart';
import 'package:fluter_firebase_authentication/screens/home.dart';
import 'package:fluter_firebase_authentication/screens/phone_auth/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //function for login
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == '' || password == '') {
      log('Please fill all details!');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        log('Log In!');
        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: ((context) => Home())));
        }
      } on FirebaseException catch (e) {
        log(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(fontSize: 20),
                ),
                hintText: 'Email Addess',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                label: Text(
                  'Password',
                  style: TextStyle(fontSize: 20),
                ),
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 25),
            CupertinoButton(
              child: Text('Log In'),
              onPressed: () {
                login();
              },
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            CupertinoButton(
              child: Text('Log In with Phone'),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignInWithPhone(),
                    ));
              },
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            CupertinoButton(
              child: Text('Create Account'),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SignUp()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
