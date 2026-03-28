import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medication_provider.dart';
import 'add_medication_screen.dart';
import '../services/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meds = context.watch<MedicationProvider>().medications;

    return Scaffold(
      appBar: AppBar(
        title: Text('MediTrack'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          )
        ],
      ),
      body: meds.isEmpty
          ? Center(child: Text('No medications added yet'))
          : ListView.builder(
              itemCount: meds.length,
              itemBuilder: (context, index) {
                final med = meds[index];
                return ListTile(
                  title: Text(med.name),
                  subtitle: Text('Dosage: ${med.dosage}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        context.read<MedicationProvider>().removeMedication(med),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddMedicationScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}