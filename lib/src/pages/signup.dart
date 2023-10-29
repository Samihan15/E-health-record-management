import 'package:ehr_management/src/services/firebase_services.dart';
import 'package:ehr_management/src/utils/widgets/snakbar.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _publicAddress = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool toggle = true;

  late String selectedUserType = 'patient';

  void Toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _publicAddress.dispose();
    _nameController.dispose();
    _ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hello user 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (!value!.contains('@gmail.com')) {
                      return 'Please enter valid email !';
                    } else if (value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: toggle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: Toggle,
                      child: !toggle
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _publicAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your public address';
                    } else if (value.length != 42) {
                      return 'Please enter valid public address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Public Address',
                    hintText: 'Enter your public address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Select role '),
                    Radio(
                      value: 'patient',
                      groupValue: selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          selectedUserType = value!;
                        });
                      },
                    ),
                    const Text('Patient'),
                    Radio(
                      value: 'doctor',
                      groupValue: selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          selectedUserType = value!;
                        });
                      },
                    ),
                    const Text('Doctor'),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await signUpFunction(
                          _emailController.text.trim(),
                          _passwordController.text.trim());

                      final result1 = await storeUserData(
                          _nameController.text.trim(),
                          _ageController.text.trim(),
                          _publicAddress.text.trim(),
                          selectedUserType);

                      if (result1 == 'success') {
                        if (selectedUserType == 'doctor') {
                          Navigator.pushNamed(context, '/barcode_page');
                        } else if (selectedUserType == 'patient') {
                          Navigator.pushNamed(context, '/home');
                        }
                      }

                      showSnackBar(context, result1!);
                    },
                    style: ButtonStyle(elevation: MaterialStateProperty.all(2)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have account ? ',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'SignIn here !',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
