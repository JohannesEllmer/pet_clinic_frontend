class Pet {
  final String id;
  final String name;
  final String type;
  final String breed;
  final String gender;
  final bool vaccinated;
  final bool chipped;
  final String chipNr;
  final String diagnose;
  final String medication;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.vaccinated,
    required this.chipped,
    required this.chipNr,
    required this.diagnose,
    required this.medication,
  });

  factory Pet.fromJson(Map<String, dynamic> j) => Pet(
    id: (j['id'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
    type: (j['type'] ?? '').toString(),
    breed: (j['breed'] ?? '').toString(),
    gender: (j['gender'] ?? '').toString(),
    vaccinated: (j['vaccinated'] ?? false) == true,
    chipped: (j['chipped'] ?? false) == true,
    chipNr: (j['chipNr'] ?? '').toString(),
    diagnose: (j['diagnose'] ?? '').toString(),
    medication: (j['medication'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'breed': breed,
    'gender': gender,
    'vaccinated': vaccinated,
    'chipped': chipped,
    'chipNr': chipNr,
    'diagnose': diagnose,
    'medication': medication,
  };
}
