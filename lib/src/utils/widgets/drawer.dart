import 'package:ehr_management/src/services/firebase_services.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String role = '';

  _getRole() async {
    String result = await getRole();
    setState(() {
      role = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Center(
              child: Text(
                'E-Health Management System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          role == 'doctor'
              ? ListTile(
                  title: const Text('Barcode Scanner'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/barcode_page');
                  },
                )
              : const SizedBox(),
          role == 'patient'
              ? ListTile(
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                )
              : const SizedBox(),
          ListTile(
            title: const Text('Prescription'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await logout();
            },
          ),
        ],
      ),
    );
  }
}
