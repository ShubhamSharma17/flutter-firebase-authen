// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_types_as_parameter_names

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_firebase_authentication/screens/phone_auth/verification_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  TextEditingController phoneController = TextEditingController();

  //fuction for OTP via phone numebr
  void sendOTP() async {
    String phone = '+91' + phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendCode) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => VerificationOTP(
                  verificationID: verificationId,
                ),
              ));
        },
        verificationCompleted: (Credential) {},
        verificationFailed: (e) {
          log(e.code.toString());
        },
        codeAutoRetrievalTimeout: (VerificationID) {},
        timeout: Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('SignInWithPhone')),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CupertinoButton(
                child: Text('Sign In'),
                onPressed: () {
                  sendOTP();
                },
                color: Colors.blue,
              )
            ],
          ),
        ));
  }
}
