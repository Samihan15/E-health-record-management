import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const Color appBarColor = Colors.deepPurple;
const Color black = Colors.black;
const Color backgroundColor = Color.fromARGB(255, 230, 227, 227);

const String ethUrl =
    'https://sepolia.infura.io/v3/7cd0595828554464ae5d1fb2ef83ffde';

String? voterPrivateKey;
const contractAddress1 = '0xEAcC03881B6E42C3F4399e76A667F282209182E6';
final Web3Client ethClient = Web3Client(ethUrl, Client());

String? privateKey;
