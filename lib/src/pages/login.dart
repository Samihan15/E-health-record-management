import 'package:ehr_management/src/services/firebase_services.dart';
import 'package:ehr_management/src/services/shared_pref.dart';
import 'package:ehr_management/src/utils/constant.dart';
import 'package:ehr_management/src/utils/widgets/snakbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _privateKey = TextEditingController();

  bool toggle = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _privateKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome again !',
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
              height: 15,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: toggle,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length <= 7) {
                  return 'Password length should be at least 7';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        toggle = !toggle;
                      });
                    },
                    child: !toggle
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off)),
                hintText: 'Enter your password',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _privateKey,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your private key';
                } else if (value.length != 64) {
                  return 'Please enter valid private key';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Private key',
                hintText: 'Enter your private key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await signInUser(_emailController.text.trim(),
                      _passwordController.text.trim());

                  final role = await getRole();
                  if (result == 'success') {
                    await SharedPref().savePrivateKey(_privateKey.text.trim());
                    setState(() {
                      privateKey = _privateKey.text.trim();
                    });
                  }
                  if (role == 'patient') {
                    Navigator.pushNamed(context, '/home');
                  } else if (role == 'doctor') {
                    Navigator.pushNamed(context, '/barcode_page');
                  }
                  showSnackBar(context, result);
                },
                style: ButtonStyle(elevation: MaterialStateProperty.all(2)),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have account ? ',
                  style: TextStyle(fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'SignUp here !',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
