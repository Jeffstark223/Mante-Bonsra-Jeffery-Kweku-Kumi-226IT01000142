class Medication {
  String id;
  String name;
  String dosage;
  List<String> times;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.times,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'times': times,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      times: List<String>.from(map['times']),
    );
  }
}