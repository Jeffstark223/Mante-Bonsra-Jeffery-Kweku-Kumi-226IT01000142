import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  void signup() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await context.read<AuthProvider>().signup(
          _username.text.trim(),
          _password.text.trim(),
        );

    setState(() => _loading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      setState(() {
        _error = "User already exists";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.health_and_safety,
                    size: 80, color: Color(0xFF27AE60)),
                const SizedBox(height: 10),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _username,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),

                const SizedBox(height: 20),

                if (_error != null)
                  Text(_error!,
                      style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : signup,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}