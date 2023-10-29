import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehr_management/src/pages/doctor/barcode.dart';
import 'package:ehr_management/src/pages/doctor/prescription_page.dart';
import 'package:ehr_management/src/pages/home.dart';
import 'package:ehr_management/src/pages/login.dart';
import 'package:ehr_management/src/pages/patient/profile.dart';
import 'package:ehr_management/src/pages/patient/profile_details_update.dart';
import 'package:ehr_management/src/pages/signup.dart';
import 'package:ehr_management/src/services/user_management.dart';
import 'package:ehr_management/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: appBarColor,
            elevation: 1,
          ),
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark),
      home: userManagament(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/profileUpdate': (context) => const UpdateDetailsPage(),
        '/add_prescription': (context) => const AddPrescription(),
        '/barcode_page': (context) => const BarCode(),
      },
    );
  }
}
