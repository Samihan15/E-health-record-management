import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';


const Color appBarColor = Colors.deepPurple;
const Color black = Colors.black;
const Color backgroundColor = Color.fromARGB(255, 230, 227, 227);

const String ethUrl =
    'https://sepolia.infura.io/v3/7cd0595828554464ae5d1fb2ef83ffde';

String? voterPrivateKey;
const contractAddress1 = '0xA4fCdD42e50cA4a2f00124E18880f5B6dE841d04';
final Web3Client ethClient = Web3Client(ethUrl, Client());

String? privateKey;
