// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_firebase_authentication/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationOTP extends StatefulWidget {
  final String verificationID;
  const VerificationOTP({Key? key, required this.verificationID})
      : super(key: key);

  @override
  State<VerificationOTP> createState() => _VerificationOTPState();
}

class _VerificationOTPState extends State<VerificationOTP> {
  TextEditingController otpController = TextEditingController();

  void verifyOTP() async {
    String otp = otpController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationID, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: ((context) => Home())));
      }
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verification Screen')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              maxLength: 6,
              controller: otpController,
              decoration: InputDecoration(
                labelText: '6-digit-OTP',
                counterText: '',
              ),
            ),
            SizedBox(height: 15),
            CupertinoButton(
                color: Colors.lightBlueAccent,
                child: Text('Verify'),
                onPressed: () {
                  verifyOTP();
                }),
          ],
        ),
      ),
    );
  }
}
