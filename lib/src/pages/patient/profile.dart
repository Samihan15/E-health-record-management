import 'package:ehr_management/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'P R O F I L E   P A G E',
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // add a logic to update current profile pic !!!!
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    radius: 70,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: Samihan Nandedkar',
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
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Address: Jalgaon',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Contact Number: 9860779443',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Public Address: ',
              style: TextStyle(fontSize: 20),
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
              style: TextStyle(fontSize: 20),
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
    );
  }
}
