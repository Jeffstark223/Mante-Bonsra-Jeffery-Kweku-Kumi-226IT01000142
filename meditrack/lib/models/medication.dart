class Medication {
  final String name;
  final String dosage;
  final String time;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      dosage: json['dosage'],
      time: json['time'],
    );
  }
}