import '../model/pet.dart';
import '../model/appointment.dart';
import '../model/chat_message.dart';
import '../model/user_profile.dart';

class MockData {
  static User user() => User(
    id: 'u1',
    firstname: 'Max',
    lastname: 'Mustermann',
    phone: '+43 660 1234567',
    role: 'owner',
  );

  static List<Pet> pets() => [
    Pet(
      id: 'p1',
      name: 'Bello',
      type: 'Dog',
      breed: 'Labrador',
      gender: 'Male',
      vaccinated: true,
      chipped: true,
      chipNr: 'AT-CHIP-001',
      diagnose: 'Leichte Ohrenentzündung.',
      medication: 'Ohrentropfen 2x täglich für 7 Tage.',
    ),
    Pet(
      id: 'p2',
      name: 'Mimi',
      type: 'Cat',
      breed: 'British Shorthair',
      gender: 'Female',
      vaccinated: true,
      chipped: false,
      chipNr: '',
      diagnose: 'Routine-Check ohne Befund.',
      medication: '—',
    ),
  ];

  static List<Appointment> appointments() => [
    Appointment(
      id: 'a1',
      petId: 'p1',
      petName: 'Bello',
      type: 'Checkup',
      vet: 'Dr. Huber',
      issue: 'Kontrolle nach Behandlung',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
    ),
    Appointment(
      id: 'a2',
      petId: 'p2',
      petName: 'Mimi',
      type: 'Vaccination',
      vet: 'Dr. Kern',
      issue: 'Jahresimpfung',
      dateTime: DateTime.now().add(const Duration(days: 10, hours: 1)),
    ),
  ];

  static List<ChatMessage> supportMessages() => [
    ChatMessage(
      id: 'm1',
      text: 'Hallo! Wie können wir helfen?',
      fromUser: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    ChatMessage(
      id: 'm2',
      text: 'Ich möchte einen Termin verschieben.',
      fromUser: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
    ),
  ];
}
