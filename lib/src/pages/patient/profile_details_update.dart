import 'package:ehr_management/src/services/firebase_services.dart';
import 'package:flutter/material.dart';

class UpdateDetailsPage extends StatefulWidget {
  const UpdateDetailsPage({Key? key}) : super(key: key);

  @override
  State<UpdateDetailsPage> createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    var users = await getUsers();
    // Load existing user data to update
    _nameController.text = users['name'];
    _ageController.text = users['age'];
    _bloodController.text = users['bloodGroup'];
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bloodController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Information',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Update your name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Update your age',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bloodController,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                hintText: 'Update your blood group',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await updateInfo(
                  _nameController.text,
                  _ageController.text,
                  _bloodController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
