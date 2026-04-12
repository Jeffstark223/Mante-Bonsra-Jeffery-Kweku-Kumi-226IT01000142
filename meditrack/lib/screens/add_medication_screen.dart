import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medication.dart';
import '../providers/medication_provider.dart';
import '../services/notification_service.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _name = TextEditingController();
  final _dosage = TextEditingController();
  TimeOfDay? _selectedTime;

  bool _loading = false;
  String? _error;

  // ── PICK TIME ─────────────────────────────
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ── SAVE ──────────────────────────────────
  Future<void> save() async {
    if (_name.text.isEmpty ||
        _dosage.text.isEmpty ||
        _selectedTime == null) {
      setState(() => _error = "Please fill all fields");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final med = Medication(
      name: _name.text.trim(),
      dosage: _dosage.text.trim(),
      time: _selectedTime!.format(context),
    );

    // Save to provider
    context.read<MedicationProvider>().addMedication(med);

    // 🔔 REAL scheduled notification
    await NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Time to take ${med.name} 💊",
      body: "Dosage: ${med.dosage}",
      time: _selectedTime!,
    );

    setState(() => _loading = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text("Add Medication"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Medication Name
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Medication Name",
                prefixIcon: const Icon(Icons.medical_services),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Dosage
            TextField(
              controller: _dosage,
              decoration: InputDecoration(
                labelText: "Dosage",
                prefixIcon: const Icon(Icons.local_pharmacy),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Time Picker
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime == null
                          ? "Select Time"
                          : _selectedTime!.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedTime == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Error
            if (_error != null)
              Text(_error!,
                  style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 10),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _loading ? null : save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Medication",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}