import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const Color appBarColor = Colors.deepPurple;
const Color black = Colors.black;
const Color backgroundColor = Color.fromARGB(255, 230, 227, 227);

const String ethUrl =
    'add sepolia eth API here';

String? voterPrivateKey;
const contractAddress1 = '0x68331F7E1506644790c46aE012A6AE254b323dDE';
final Web3Client ethClient = Web3Client(ethUrl, Client());

String? privateKey;
