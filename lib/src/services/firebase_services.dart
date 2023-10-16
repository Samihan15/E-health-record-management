import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User? user = _auth.currentUser;

Future<String> registerUser(email, password, name, publicAddress, age) async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('users').doc(user!.uid).set({
      'name': name,
      'age': age,
      'publicAddress': publicAddress,
      'role': 'patient'
    });

    return 'success';
  } catch (err) {
    print('Error occur while registering user : $err');
    return err.toString();
  }
}

Future<String> signInUser(email, password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return 'success';
  } catch (err) {
    print('Error occur while logingIn');
    if (err is FirebaseAuthException) {
      return err.message.toString();
    } else {
      return 'Login error';
    }
  }
}

Future<void> logout() async {
  try {
    await _auth.signOut();
  } catch (err) {
    print('Error while loging out: $err');
  }
}
