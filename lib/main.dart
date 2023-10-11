import 'package:ehr_management/pages/home.dart';
import 'package:ehr_management/pages/login.dart';
import 'package:ehr_management/pages/profile.dart';
import 'package:ehr_management/pages/profile_details_update.dart';
import 'package:ehr_management/pages/signup.dart';
import 'package:ehr_management/utils/constant.dart';
import 'package:flutter/material.dart';

void main() {
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
            backgroundColor: backgroundColor,
            elevation: 1,
          ),
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.light),
      home: const UpdateDetailsPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/profileUpdate': (context) => const UpdateDetailsPage()
      },
    );
  }
}
