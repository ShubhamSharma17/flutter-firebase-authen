// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_firebase_authentication/screens/email_auth/login.dart';

import 'package:fluter_firebase_authentication/screens/home.dart';
import 'package:fluter_firebase_authentication/screens/phone_auth/signin.dart';
import 'package:flutter/material.dart';

void main() async {
  //for firebase auth
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //for firebase firestore

  //this for only collection
  // QuerySnapshot querySnapshot =
  //     await FirebaseFirestore.instance.collection('users').get();
  // for (var doc in querySnapshot.docs) {
  //   log(doc.data().toString());
  // }

  //this for an specific document(user)
  // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc("Zmu647SK7Z7iaddoZeUU")
  //     .get();
  // log(documentSnapshot.data().toString());

  //for saved users!
  // Map<String, dynamic> userDetails = {
  //   'name': 'Kailash Upadhyay',
  //   'email': 'kailashupadhyay@gmail.com'
  // };
  //in this way User ID automatically generate by firebase
  // await FirebaseFirestore.instance.collection('users').add(userDetails);
  // log('User has Saved!');

  //in this way manually ID  generate by us
  // FirebaseFirestore.instance
  //     .collection('users')
  //     .doc('manually ID is here!')
  //     .set(userDetails);
  // log('User has Saved!');

  //for update user dateail
  // FirebaseFirestore.instance
  //     .collection('users')
  //     .doc('manually ID is here!')
  //     .update({'email': 'kailash@gmail.com'});

  // log('User details has update!');

  //for delete user dateail
  // FirebaseFirestore.instance
  //     .collection('users')
  //     .doc('manually ID is here!')
  //     .delete();
  // log('User details has deleted!');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          (FirebaseAuth.instance.currentUser != null) ? Home() : LoginScreen(),
    );
  }
}
