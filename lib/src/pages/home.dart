import 'package:ehr_management/src/services/firebase_services.dart';
import 'package:ehr_management/src/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:ehr_management/src/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "patient";

  getResult() async {
    result = await getRole();
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'P A T I E N T\'s   H I S T O R Y',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {});
        },
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doctor\'s Name: Samihan Nandedkar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Doctor\'s Public Address: 0x52520984471d8D1b34B3c416e42A2ab22f56a363',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Prescription: Crosin',
                        style: TextStyle(
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
                Navigator.pushNamed(context, '/add_prescription');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
