import 'package:flutter/material.dart';
import '../models/medication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MedicationProvider extends ChangeNotifier {
  List<Medication> _medications = [];

  List<Medication> get medications => _medications;

  MedicationProvider() {
    loadMedications();
  }

  void addMedication(Medication med) {
    _medications.add(med);
    saveMedications();
    notifyListeners();
  }

  void removeMedication(Medication med) {
    _medications.removeWhere((m) => m.id == med.id);
    saveMedications();
    notifyListeners();
  }

  Future<void> saveMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> meds = _medications.map((m) => json.encode(m.toMap())).toList();
    await prefs.setStringList('medications', meds);
  }

  Future<void> loadMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? meds = prefs.getStringList('medications');
    if (meds != null) {
      _medications = meds.map((m) => Medication.fromMap(json.decode(m))).toList();
      notifyListeners();
    }
  }
}