import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medication_provider.dart';
import '../models/medication.dart';
import 'package:uuid/uuid.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  void addMedication() {
    final med = Medication(
      id: Uuid().v4(),
      name: _nameController.text,
      dosage: _dosageController.text,
      times: ['08:00', '20:00'], // Default times
    );
    context.read<MedicationProvider>().addMedication(med);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medication')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Medication Name'),
            ),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addMedication, child: Text('Add')),
          ],
        ),
      ),
    );
  }
}