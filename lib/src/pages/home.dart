import 'package:ehr_management/src/pages/doctor/prescription_page.dart';
import 'package:ehr_management/src/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../services/functions.dart';

class HomePage extends StatefulWidget {
  final String? scannedResult;

  const HomePage({Key? key, this.scannedResult}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "patient";
  List<Map<String, dynamic>> medicalHistory = [];

  @override
  void initState() {
    super.initState();
    loadMedicalHistory();
  }

  Future<void> loadMedicalHistory() async {
    if (result == 'patient' && widget.scannedResult != null) {
      try {
        var patientAddress = widget.scannedResult;
        List<dynamic> history = await viewMedicalHistoryFunction(
            EthereumAddress.fromHex(patientAddress!));
        setState(() {
          medicalHistory = history.cast<Map<String, dynamic>>();
        });
      } catch (error) {
        print('Error loading medical history: $error');
      }
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
          setState(() {});
        },
        child: ListView.builder(
          itemCount: medicalHistory.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doctor\'s Name: ${medicalHistory[index]['doctorName']}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Doctor\'s Address: ${medicalHistory[index]['doctorAddress']}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Prescription: ${medicalHistory[index]['prescriptionDetails']}',
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
        ),
      ),
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
}
