import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/constant.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(
      ContractAbi.fromJson(abi, 'EHealthManagementSystem'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String?> callFunction(Web3Client ethClient, String privateKey,
    String funcname, List<dynamic> args) async {
  final contract = await loadContract();

  final credentials = EthPrivateKey.fromHex(privateKey);
  final ethFunction = contract.function(funcname);

  try {
    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );

    return result;
  } catch (e) {
    print("Error calling function: $e");
    return null;
  }
}

// Define a function to call the addPatient function
Future<void> addPatientFunction(
    String name, int age, EthereumAddress publicAddress, String email) async {
  final args = [name, BigInt.from(age), publicAddress, email];
  await callFunction(ethClient, privateKey!, 'addPatient', args);
}

// Define a function to call the addDoctor function
Future<void> addDoctorFunction(
    String name, int age, EthereumAddress publicAddress, String email) async {
  final args = [name, BigInt.from(age), publicAddress, email];
  await callFunction(ethClient, privateKey!, 'addDoctor', args);
}

// Define a function to call the addPrescription function
Future<void> addPrescriptionFunction(EthereumAddress patientAddress,
    String date, String prescription, String doctorName) async {
  final args = [patientAddress, date, prescription, doctorName];
  await callFunction(ethClient, privateKey!, 'addPrescription', args);
}

Future<List<dynamic>> viewMedicalHistoryFunction(
    EthereumAddress patientAddress) async {
  List<dynamic> args = [patientAddress];
  List<dynamic> history =
      (await callFunction(ethClient, privateKey!, 'viewMedicalHistory', args))
          as List;

  return history;
}

Future<void> updatePatientInfoFunction(EthereumAddress patientAddress,
    String newName, int newAge, String newEmail) async {
  final args = [patientAddress, newName, BigInt.from(newAge), newEmail];
  await callFunction(ethClient, privateKey!, 'updatePatientInfo', args);
}
