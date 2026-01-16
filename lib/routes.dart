import 'package:flutter/material.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/profile.dart';
import 'screens/pets.dart';
import 'screens/pet_edit_screen.dart';
import 'screens/appointments.dart';
import 'screens/new_appointment.dart';
import 'screens/support.dart';
import 'screens/DatePicker.dart';

import 'model/pet.dart';

class Routes {
  static const login = '/';
  static const register = '/register';
  static const profile = '/profile';
  static const pets = '/pets';
  static const petEdit = '/pets/edit';

  static const appointments = '/appointments';
  static const appointmentNew = '/appointments/new';
  static const appointmentDateTime = '/appointments/datetime';

  static const support = '/support';
}

final Map<String, WidgetBuilder> routes = {
  Routes.login: (_) => const LoginScreen(),
  Routes.register: (_) => const RegisterScreen(),
  Routes.profile: (_) => const ProfileScreen(),
  Routes.pets: (_) => const PetsScreen(),
  Routes.petEdit: (context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Pet;
    return PetEditScreen(pet: pet);
  },

  Routes.appointments: (_) => const AppointmentsScreen(),
  Routes.appointmentNew: (_) => const NewAppointmentScreen(),
  Routes.appointmentDateTime: (_) => const AppointmentDateTimeScreen(),
  Routes.support: (_) => const SupportScreen(),
};
