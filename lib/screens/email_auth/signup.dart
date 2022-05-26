// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //function for create account
  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();

    if (email == '' || password == '' || confirmpassword == '') {
      log('Please fill all the details!');
    } else if (password != confirmpassword) {
      log('Password couldn\'t match');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        log('User created!');
        if (userCredential != null) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email Address'),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              controller: passwordController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              controller: confirmPasswordController,
            ),
            SizedBox(height: 15),
            CupertinoButton(
              child: Text('Create Account'),
              onPressed: () {
                createAccount();
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
