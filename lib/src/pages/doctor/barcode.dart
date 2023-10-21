import 'package:ehr_management/src/utils/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarCode extends StatefulWidget {
  const BarCode({super.key});

  @override
  State<BarCode> createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S C A N   Q R   C O D E   P A G E",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() {});
        },
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/barcode.gif'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                  setState(() {
                    if (res is String) {
                      result = res;
                    }
                  });
                },
                style: ButtonStyle(elevation: MaterialStateProperty.all(2)),
                child: const Text(
                  'Scan Barcode',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
