import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/functions.dart';

class AddPrescription extends StatefulWidget {
  final EthereumAddress patientAddress;

  const AddPrescription({Key? key, required this.patientAddress})
      : super(key: key);

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  final TextEditingController _prescriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _prescriptionController.dispose();
  }

  Future<String> getDoctor() async {
    try {
      var user = FirebaseAuth.instance.currentUser!.uid;
      var doctor =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      return doctor['name'];
    } catch (err) {
      print(err);
    }
    return 'no user found';
  }

  Future<void> submitPrescription() async {
    try {
      String prescriptionText = _prescriptionController.text;

      if (prescriptionText.isNotEmpty) {
        final doctorName = await getDoctor();

        if (widget.patientAddress != null) {
          await addPrescriptionFunction(
            widget.patientAddress,
            DateTime.now().toString(),
            prescriptionText,
            doctorName,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prescription added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Patient address is null. Unable to submit prescription.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a prescription before submitting.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error submitting prescription: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.patientAddress);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Prescription',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _prescriptionController,
              decoration: InputDecoration(
                labelText: 'Prescription',
                labelStyle: const TextStyle(fontSize: 18),
                hintText: 'Add prescription here',
                hintStyle: const TextStyle(fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: submitPrescription,
              style: ButtonStyle(elevation: MaterialStateProperty.all(2)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
