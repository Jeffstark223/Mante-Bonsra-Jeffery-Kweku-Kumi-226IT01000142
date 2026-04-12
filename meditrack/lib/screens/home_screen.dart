import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import 'add_medication_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
  backgroundColor: const Color(0xFF2F80ED),
  child: const Icon(Icons.add),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
    );
  },
),
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "MediTrack",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFF2F80ED),
              child: Icon(Icons.person, color: Colors.white),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Good Day 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Here’s your medication overview",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 🔵 MAIN CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F80ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Today's Progress",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "2 of 5 medications taken",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Medications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
  child: Consumer<MedicationProvider>(
    builder: (context, provider, child) {
      final meds = provider.medications;

      if (meds.isEmpty) {
        return const Center(child: Text("No medications yet"));
      }

      return ListView.builder(
        itemCount: meds.length,
        itemBuilder: (context, index) {
          final med = meds[index];

          return MedicationCard(
            name: med.name,
            dosage: med.dosage,
            time: med.time,
          );
        },
      );
    },
  ),
),
          ],
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String time;

  const MedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF2F80ED),
            child: Icon(Icons.medication, color: Colors.white),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("$dosage • $time",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          const Icon(Icons.check_circle_outline, color: Colors.green),
        ],
      ),
    );
  }
}