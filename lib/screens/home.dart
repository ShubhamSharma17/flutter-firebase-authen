// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
        context, CupertinoPageRoute(builder: ((context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    //method for save date of user
    void saveUser() async {
      String name = nameController.text.trim();
      String email = emailController.text.trim();

      nameController.clear();
      emailController.clear();

      if (name != '' && email != '') {
        Map<String, dynamic> userCredencials = {'name': name, 'email': email};

        FirebaseFirestore.instance.collection('example1').add(userCredencials);
        log('User credencials has saved');
      } else {
        log('please enter right credenials');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home '),
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Name', hintText: 'Enter Your Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter Your Email Address'),
            ),
            SizedBox(height: 15),
            CupertinoButton(
              color: Colors.blueGrey,
              child: Text('Save'),
              onPressed: () {
                saveUser();
              },
            ),
            SizedBox(height: 30),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('example1').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return ListTile(
                            title: Text(userMap['name']),
                            subtitle: Text(userMap['email']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                String id = snapshot.data!.docs[index].id;
                                FirebaseFirestore.instance
                                    .collection('example1')
                                    .doc(id)
                                    .delete();
                                log('User Deleted!');
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('No Data!');
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
