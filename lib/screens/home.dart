import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../screens/appointments.dart';
import '../../screens/pets.dart';
import '../../screens/profile.dart';
import '../../screens/support.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    ProfileScreen(),
    AppointmentsScreen(),
    PetsScreen(),
    SupportScreen(),
  ];

  String get _title {
    switch (_index) {
      case 0:
        return 'My Profile';
      case 1:
        return 'Appointments';
      case 2:
        return 'My Pets';
      case 3:
        return 'Support';
      default:
        return 'PetClinic';
    }
  }

  IconData _iconFor(int i) {
    switch (i) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.event_note;
      case 2:
        return Icons.pets;
      case 3:
        return Icons.support_agent;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital, color: AppTheme.brandBlue),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppTheme.brandBlue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) {
                  final selected = _index == i;
                  return IconButton(
                    onPressed: () => setState(() => _index = i),
                    icon: Icon(
                      _iconFor(i),
                      color: selected ? Colors.white : Colors.white70,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: _pages[_index],
    );
  }
}
