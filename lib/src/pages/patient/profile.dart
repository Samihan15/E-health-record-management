import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehr_management/src/utils/constant.dart';
import 'package:ehr_management/src/utils/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/firebase_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in
        setState(() {
          _isLoading = true;
        });
        final userId = user.uid;
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        docRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            final data = docSnapshot.data() as Map<String, dynamic>;
            if (data.containsKey('imgUrl')) {
              final imgUrl = data['imgUrl'] as String;
              setState(() {
                _image = imgUrl;
                _isLoading = false;
              });
            }
          }
        });
      } else {
        // User is signed out
        setState(() {
          _image = null;
          _isLoading = false;
        });
      }
    });
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path); // Convert to a File
      final downloadUrl = await uploadProfileImage(file);
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

      setState(() {
        _isLoading = true;
      });

      try {
        docRef.update({'imgUrl': downloadUrl});
        print('field updated');
      } catch (err) {
        print(err);
      }

      setState(() {
        _image = downloadUrl;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/profileUpdate');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : _image == null
                              ? const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/profile.jpg'),
                                  radius: 70,
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_image.toString()),
                                  radius: 70,
                                ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: Divesh Patil',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Age: 21',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                height: 4,
                color: black,
              ),
              const Text(
                'Blood Group: O+',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Address: Jalgaon',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Contact Number: 9860779443',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Public Address: ',
                style: TextStyle(fontSize: 18),
              ),
              const Divider(
                height: 4,
                color: black,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Public Address QR code: ',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: QrImageView(
                  data: '1234567890',
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
