class Appointment {
  final String id;
  final String petId;
  final String petName;
  final String vet;
  final String type;
  final String issue;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.petId,
    required this.petName,
    required this.vet,
    required this.type,
    required this.issue,
    required this.dateTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
    id: (j['id'] ?? '').toString(),
    petId: (j['petId'] ?? '').toString(),
    petName: (j['petName'] ?? '').toString(),
    vet: (j['petName'] ?? '').toString(),
    type: (j['type'] ?? '').toString(),
    issue: (j['issue'] ?? '').toString(),
    dateTime: DateTime.tryParse((j['dateTime'] ?? '').toString()) ??
        DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'petName': petName,
    'type': type,
    'issue': issue,
    'dateTime': dateTime.toIso8601String(),
  };
}
