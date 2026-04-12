import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/medication.dart';

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
    _medications.remove(med);
    saveMedications();
    notifyListeners();
  }

  // 💾 SAVE DATA
  Future<void> saveMedications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> meds =
        _medications.map((m) => jsonEncode(m.toJson())).toList();

    prefs.setStringList('medications', meds);
  }

  // 📥 LOAD DATA
  Future<void> loadMedications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? meds = prefs.getStringList('medications');

    if (meds != null) {
      _medications = meds
          .map((m) => Medication.fromJson(jsonDecode(m)))
          .toList();

      notifyListeners();
    }
  }
}