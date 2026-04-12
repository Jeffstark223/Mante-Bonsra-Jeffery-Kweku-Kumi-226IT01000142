import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2F80ED),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text(
              "John Doe",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Text(
              "johndoe@email.com",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _buildOption(Icons.lock, "Change Password"),
            _buildOption(Icons.notifications, "Notifications"),
            _buildOption(Icons.info, "About App"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF2F80ED)),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}