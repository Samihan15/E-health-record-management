import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> signUpFunction(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user?.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else {
      return e.toString();
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String?> storeUserData(
    String name, String age, String publicAddress, String role) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'age': age,
        'publicAddress': publicAddress,
        'role': role,
        'imgUrl': '',
        'bloodGroup': ''
      });
      return 'success';
    } else {
      return 'User not authenticated.';
    }
  } catch (e) {
    print("Error storing user data: $e");
    return 'Error storing user data: $e';
  }
}

Future<String> signInUser(email, password) async {
  try {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return 'success';
  } catch (err) {
    print('Error occur while logging in');
    if (err is FirebaseAuthException) {
      return err.message.toString();
    } else {
      return err.toString();
    }
  }
}

Future<void> logout() async {
  final auth = FirebaseAuth.instance;
  await auth.signOut();
}

Future<String> getRole() async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final result =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final role = result['role'];
    return role;
  } catch (err) {
    return 'patient';
  }
}

Future<String> uploadProfileImage(File imageFile) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_images/${user!.uid}');
    try {
      await storageRef.delete();
      print('Previous photo deleted');
    } catch (deleteError) {
      print('No previous photo found');
    }

    // Upload the new photo
    final TaskSnapshot uploadTask = await storageRef.putFile(imageFile);
    final imageUrl = await uploadTask.ref.getDownloadURL();

    print('Upload successful');
    return imageUrl.toString();
  } catch (error) {
    print('Error uploading image: $error');
    throw error;
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUsers() async {
  var userId = FirebaseAuth.instance.currentUser?.uid;
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}

Future<void> updateInfo(
    String newName, String newAge, String bloodGroup) async {
  try {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef
        .update({'name': newName, 'age': newAge, 'bloodGroup': bloodGroup});

    print('User info updated successfully');
  } catch (error) {
    print('Error updating user info: $error');
  }
}
