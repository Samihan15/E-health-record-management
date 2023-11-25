import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';

import '../../services/firebase_services.dart';
import '../../utils/constant.dart';
import '../../utils/widgets/drawer.dart';
import 'profile_details_update.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _isLoading = true;
        });
        final userId = user.uid;
        final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

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
      final file = File(image.path);
      final downloadUrl = await uploadProfileImage(file);
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

      setState(() {
        _isLoading = true;
      });

      try {
        docRef.update({'imgUrl': downloadUrl});
        print('Field updated');
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateDetailsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUsers(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error}'));
          } else {
            var user = snapshot.data?.data();
            return RefreshIndicator(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?['name'] ?? 'No Name',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              user?['age'] ?? 'No Age',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 4,
                      color: black,
                    ),
                    Text(
                      'Blood Group: ${user?['bloodGroup'] ?? 'No Blood Group'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user?['publicAddress'] ?? 'No Public Address',
                      style: const TextStyle(fontSize: 18),
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
                        data: user?['publicAddress'] ?? 'No Public Address',
                        version: QrVersions.auto,
                        size: 250.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}
