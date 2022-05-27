// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_firebase_authentication/screens/email_auth/login.dart';
import 'package:fluter_firebase_authentication/screens/phone_auth/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    log('Log Out');
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: ((context) => SignInWithPhone())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home '),
      ),
      body: Center(
          child: CupertinoButton(
        color: Colors.blueAccent,
        child: Text('Log Out'),
        onPressed: () {
          logOut();
        },
      )),
    );
  }
}
