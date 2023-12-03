import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/constant.dart';
import 'shared_pref.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String?> callFunction(Web3Client ethClient, String privateKey,
    String funcname, List<dynamic> args) async {
  final contract = await loadContract();
  if (privateKey == null) {
    print('Private key is null. Unable to execute function.');
    return null;
  }

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

void handleTransactionFailure(String functionName, String? result) {
  if (result == null) {
    print(
        'Failed to execute $functionName. Check the Ethereum node logs for details.');
  } else {
    print('Failed to execute $functionName. Error: $result');
  }
}

Future<void> addPrescriptionFunction(EthereumAddress patientAddress,
    String date, String prescription, String doctorName) async {
  final args = [patientAddress, date, prescription, doctorName];
  String? storedPrivateKey = await SharedPref().getPrivateKey();
  dynamic result =
      await callFunction(ethClient, storedPrivateKey!, 'addPrescription', args);

  if (result != null && result is String && result.startsWith('0x')) {
    print('Prescription added successfully: $result');
  } else {
    handleTransactionFailure('addPrescriptionFunction', result?.toString());
  }
}

Future<void> addPatientFunction(
    String name, int age, EthereumAddress publicAddress, String email) async {
  try {
    final args = [name, BigInt.from(age), publicAddress, email];
    String? result =
        await callFunction(ethClient, privateKey!, 'addPatient', args);
  } catch (err) {
    print('error in addPatientFunction : ${err}');
  }
}

Future<void> addDoctorFunction(
    String name, int age, EthereumAddress publicAddress, String email) async {
  try {
    final args = [name, BigInt.from(age), publicAddress, email];
    String? result =
        await callFunction(ethClient, privateKey!, 'addDoctor', args);
  } catch (err) {
    print('error in addPatientFunction : ${err}');
  }
}

Future<void> handleFunctionCall(String functionName, List<dynamic> args) async {
  String? storedPrivateKey = await SharedPref().getPrivateKey();
  String? result =
      await callFunction(ethClient, storedPrivateKey!, functionName, args);

  if (result != null && result.startsWith('0x')) {
    print('$functionName executed successfully: $result');
  } else {
    handleTransactionFailure(functionName, result);
  }
}

Future<List<dynamic>> viewMedicalHistoryFunction(
    EthereumAddress patientAddress) async {
  final args = [patientAddress];
  dynamic result = await ask('viewMedicalHistory', args, ethClient);
  print(result);
  return result[0];
}

Future<void> updatePatientInfoFunction(EthereumAddress patientAddress,
    String newName, int newAge, String newEmail) async {
  String? storedPrivateKey = await SharedPref().getPrivateKey();
  final args = [patientAddress, newName, BigInt.from(newAge), newEmail];
  String? result = await callFunction(
      ethClient, storedPrivateKey!, 'updatePatientInfo', args);

  if (result != null && result.startsWith('0x')) {
    print('Patient info updated successfully: $result');
  } else {
    handleTransactionFailure('updatePatientInfoFunction', result);
  }
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}
