import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../model/pets_repository.dart';
import '../../model/pet.dart';
import '../model/appointments_repository.dart';
import '../model/appointment.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _petsRepo = PetsRepository();
  final _repo = AppointmentsRepository();

  Pet? _selectedPet;
  List<Pet> _pets = [];

  final _type = TextEditingController();
  final _issue = TextEditingController();
  final _vet = TextEditingController(text: '');

  DateTime? _date;
  TimeOfDay? _time;

  bool _loadingPets = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    setState(() => _loadingPets = true);
    final res = await _petsRepo.listPets();
    if (!mounted) return;
    if (res.isSuccess) {
      _pets = res.data ?? [];
      _selectedPet = _pets.isNotEmpty ? _pets.first : null;
    }
    setState(() => _loadingPets = false);
  }

  @override
  void dispose() {
    _type.dispose();
    _issue.dispose();
    _vet.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (t == null) return;

    setState(() {
      _date = d;
      _time = t;
    });
  }

  DateTime? get _combined {
    if (_date == null || _time == null) return null;
    return DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
  }

  Future<void> _save() async {
    if (_selectedPet == null) return;
    final dt = _combined;
    if (dt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Datum/Zeit wählen.')),
      );
      return;
    }

    setState(() => _saving = true);

    final a = Appointment(
      id: '',
      petId: _selectedPet!.id,
      petName: _selectedPet!.name,
      type: _type.text.trim(),
      vet: _vet.text.trim(),
      issue: _issue.text.trim(),
      dateTime: dt,
    );

    final res = await _repo.create(a);

    if (!mounted) return;
    setState(() => _saving = false);

    if (res.isSuccess) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Fehler')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital, color: AppTheme.brandBlue),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.panelBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Pet'),
              const SizedBox(height: 8),
              _loadingPets
                  ? const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ))
                  : DropdownButtonFormField<Pet>(
                value: _selectedPet,
                items: _pets
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (p) => setState(() => _selectedPet = p),
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 12),
              const Text('Name'),
              const SizedBox(height: 6),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: _selectedPet?.name ?? 'Name',
                ),
              ),
              const SizedBox(height: 10),
              const Text('Type'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _type,
                decoration: const InputDecoration(hintText: 'Type'),
              ),
              const SizedBox(height: 10),
              const Text('Issue / TODO'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _issue,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(hintText: 'Todo / Issues'),
              ),
              const SizedBox(height: 12),
              const Text('Appointment Date'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _combined == null ? '—' : '${_combined!.toLocal()}'.split('.').first,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Select Date'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                    height: 18, width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Save new Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
