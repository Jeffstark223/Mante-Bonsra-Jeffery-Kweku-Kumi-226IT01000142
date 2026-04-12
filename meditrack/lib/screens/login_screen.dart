import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/biometric_service.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'main_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final BiometricService _biometricService = BiometricService();

  bool _loading = false;
  String? _error;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final available = await _biometricService.isBiometricAvailable();
    setState(() {
      _biometricAvailable = available;
    });
  }

  void login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await context.read<AuthProvider>().login(
          _username.text.trim(),
          _password.text.trim(),
        );

    setState(() => _loading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
       MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() {
        _error = "Invalid username or password";
      });
    }
  }

  Future<void> _loginWithBiometrics() async {
    final isAuthenticated = await _biometricService.authenticate();

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
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
                Icon(Icons.medical_services,
                    size: 80, color: Color(0xFF2F80ED)),
                const SizedBox(height: 10),
                const Text(
                  "MediTrack",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                    onPressed: _loading ? null : login,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                  child: const Text("Create Account"),
                )
                if (_biometricAvailable) ...[
  const SizedBox(height: 10),
  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: _loginWithBiometrics,
      icon: const Icon(Icons.fingerprint),
      label: const Text("Login with Face ID / Fingerprint"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2F80ED),
        side: const BorderSide(color: Color(0xFF2F80ED)),
      ),
    ),
  ),
],
              ],
            ),
          ),
        ),
      ),
    );
  }
}