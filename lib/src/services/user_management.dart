import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/doctor/barcode.dart';
import '../pages/home.dart';
import '../pages/login.dart';

Widget userManagament() {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasData && snapshot.data != null) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (userSnapshot.hasData) {
              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final role = userData['role'];
              if (role == 'patient') {
                return const HomePage();
              } else if (role == 'doctor') {
                return const BarCode();
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          },
        );
      } else {
        return const LoginPage();
      }
    },
  );
}
