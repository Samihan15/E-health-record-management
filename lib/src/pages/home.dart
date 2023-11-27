import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehr_management/src/pages/doctor/prescription_page.dart';
import 'package:ehr_management/src/utils/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../services/firebase_services.dart';
import '../services/functions.dart';
import '../services/shared_pref.dart';

class HomePage extends StatefulWidget {
  final String? scannedResult;

  const HomePage({Key? key, this.scannedResult}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "patient";
  List<dynamic> medicalHistory = [];

  @override
  void initState() {
    super.initState();
    loadMedicalHistory();
  }

  Future<void> loadMedicalHistory() async {
    String? storedPrivateKey = await SharedPref().getPrivateKey();
    print('Stored Private Key: $storedPrivateKey');

    result = await getRole();
    print('User role: $result');

    if (result == 'patient') {
      var patientAddress = await getPatientAddressFromFirebase();
      print('Patient Address: $patientAddress');
      List<dynamic> list = await viewMedicalHistoryFunction(
          EthereumAddress.fromHex(patientAddress!));
      print(result);
      setState(() {
        medicalHistory = list;
      });
      print(medicalHistory);
    } else {
      var patientAddress = await getPatientAddressFromFirebase();
      print('Patient Address: $patientAddress');
      List<dynamic> list = await viewMedicalHistoryFunction(
          EthereumAddress.fromHex(widget.scannedResult!));
      print(result);
      setState(() {
        medicalHistory = list;
      });
      print(medicalHistory);
    }
  }

  Future<String?> getPatientAddressFromFirebase() async {
    try {
      var userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          var patientAddress = userSnapshot['publicAddress'];

          if (patientAddress != null && patientAddress.isNotEmpty) {
            return patientAddress;
          } else {
            print('Patient address is null or empty in Firebase');
            return null;
          }
        } else {
          print('User not found in Firebase');
          return null;
        }
      } else {
        print('User not authenticated.');
        return null;
      }
    } catch (error) {
      print('Error fetching patient address from Firebase: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient\'s History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500));
            await loadMedicalHistory();
          },
          child: buildMedicalHistoryUI()),
      drawer: const MyDrawer(),
      floatingActionButton: result == 'doctor'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPrescription(
                            patientAddress: EthereumAddress.fromHex(
                                widget.scannedResult!))));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget buildMedicalHistoryUI() {
    return ListView.builder(
      itemCount: medicalHistory.length,
      itemBuilder: (BuildContext context, int index) {
        var prescriptionList = medicalHistory[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${prescriptionList[0]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Medicine Name: ${prescriptionList[1]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Doctor Address: ${prescriptionList[2]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Doctor Name: ${prescriptionList[3]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
