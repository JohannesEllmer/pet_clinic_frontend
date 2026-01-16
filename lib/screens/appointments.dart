import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../model/appointments_repository.dart';
import '../model/appointment.dart';
import 'new_appointment.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _repo = AppointmentsRepository();
  late Future<List<Appointment>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Appointment>> _load() async {
    final res = await _repo.list();
    if (!res.isSuccess) throw Exception(res.error);
    return res.data ?? [];
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _newAppointment() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const NewAppointmentScreen()),
    );
    if (changed == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          SizedBox(
            width: 260,
            child: ElevatedButton(
              onPressed: _newAppointment,
              child: const Text('New Appointment'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.panelBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.brandBlue.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Recent Appointments',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<Appointment>>(
                      future: _future,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snap.hasError) return Center(child: Text('${snap.error}'));
                        final items = snap.data ?? [];
                        if (items.isEmpty) {
                          return const Center(child: Text('Keine Termine.'));
                        }

                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final a = items[i];
                            return _AppointmentCard(a: a);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.a});
  final Appointment a;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45),
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Date', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              Expanded(child: Text('${a.dateTime.toLocal()}'.split('.').first)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              border: Border.all(color: Colors.black45),
            ),
            child: Row(
              children: const [
                Expanded(child: Center(child: Text('Petname'))),
                Expanded(child: Center(child: Text('Type'))),
                Expanded(child: Center(child: Text('Vet'))),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Gender', style: Theme.of(context).textTheme.labelMedium)),
              Expanded(child: Text('Breed', style: Theme.of(context).textTheme.labelMedium)),
              Expanded(child: Text('Medication', style: Theme.of(context).textTheme.labelMedium)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: Text('Diagnosis\n${a.issue}')),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: const Center(child: Text('Treatments')),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Pet'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
