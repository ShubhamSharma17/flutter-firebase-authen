// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluter_firebase_authentication/screens/email_auth/login.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilePic;
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    log('Log Out');
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: ((context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    //method for save date of user
    void saveUser() async {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String ageSring = ageController.text.trim();

      int age = int.parse(ageSring);

      nameController.clear();
      emailController.clear();
      ageController.clear();

      if (name != '' && email != '' && ageSring != '' && profilePic != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('profilepictures')
            .child(Uuid().v1())
            .putFile(profilePic!);

        StreamSubscription taskSubscription =
            uploadTask.snapshotEvents.listen((snapshot) {
          double percentage =
              snapshot.bytesTransferred / snapshot.totalBytes * 100;
          log(percentage.toString());
        });

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        taskSubscription.cancel();

        Map<String, dynamic> userCredencials = {
          'name': name,
          'email': email,
          'age': age,
          'profilePic': downloadUrl,
        };

        FirebaseFirestore.instance.collection('example1').add(userCredencials);
        log('User credencials has saved');
      } else {
        log('please enter right credenials');
      }
      setState(() {
        profilePic = null;
      });
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
            CupertinoButton(
              onPressed: () async {
                XFile? selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (selectedImage != null) {
                  File convertedFile = File(selectedImage.path);
                  setState(() {
                    profilePic = convertedFile;
                  });
                  log('Image selected!');
                } else {
                  log('Image not selected!');
                }
              },
              padding: EdgeInsets.zero,
              child: CircleAvatar(
                // backgroundColor: Colors.blueGrey,
                radius: 40,
                backgroundImage:
                    (profilePic != null) ? FileImage(profilePic!) : null,
              ),
            ),
            SizedBox(height: 15),
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
            TextField(
              controller: ageController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  InputDecoration(labelText: 'Age', hintText: 'Enter Your Age'),
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
              stream: FirebaseFirestore.instance
                  .collection('example1')
                  .where('age', isGreaterThanOrEqualTo: 0)
                  .snapshots(),
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
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userMap['profilePic']),
                            ),
                            title:
                                Text(userMap['name'] + '(${userMap['age']})'),
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
