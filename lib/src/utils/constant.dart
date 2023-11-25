import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const Color appBarColor = Colors.deepPurple;
const Color black = Colors.black;
const Color backgroundColor = Color.fromARGB(255, 230, 227, 227);

const String ethUrl =
    'https://sepolia.infura.io/v3/7cd0595828554464ae5d1fb2ef83ffde';

String? voterPrivateKey;
const contractAddress1 = '0x5C74711b064D639c96ac707F2264C2f05Da80Fc0';
final Web3Client ethClient = Web3Client(ethUrl, Client());

String? privateKey;
