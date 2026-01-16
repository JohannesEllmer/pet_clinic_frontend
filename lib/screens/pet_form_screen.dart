import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../model/pets_repository.dart';
import '../model/pet.dart';

class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key, this.pet});
  final Pet? pet;

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _repo = PetsRepository();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _type;
  late final TextEditingController _breed;
  late final TextEditingController _gender;
  late final TextEditingController _chipNr;

  bool _vaccinated = false;
  bool _chipped = false;

  final _diagnose = TextEditingController();
  final _medication = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    _name = TextEditingController(text: p?.name ?? '');
    _type = TextEditingController(text: p?.type ?? '');
    _breed = TextEditingController(text: p?.breed ?? '');
    _gender = TextEditingController(text: p?.gender ?? '');
    _chipNr = TextEditingController(text: p?.chipNr ?? '');
    _vaccinated = p?.vaccinated ?? false;
    _chipped = p?.chipped ?? false;
    _diagnose.text = p?.diagnose ?? '';
    _medication.text = p?.medication ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _type.dispose();
    _breed.dispose();
    _gender.dispose();
    _chipNr.dispose();
    _diagnose.dispose();
    _medication.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);

    final pet = Pet(
      id: widget.pet?.id ?? '',
      name: _name.text.trim(),
      type: _type.text.trim(),
      breed: _breed.text.trim(),
      gender: _gender.text.trim(),
      vaccinated: _vaccinated,
      chipped: _chipped,
      chipNr: _chipNr.text.trim(),
      diagnose: _diagnose.text.trim(),
      medication: _medication.text.trim(),
    );

    final res = widget.pet == null
        ? await _repo.createPet(pet)
        : await _repo.updatePet(pet);

    if (!mounted) return;

    setState(() => _loading = false);

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
    final isEdit = widget.pet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Add/Edit Pet' : 'Add/Edit Pet'),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LabelField('Name', _name),
                const SizedBox(height: 10),
                _LabelField('Type', _type),
                const SizedBox(height: 10),
                _LabelField('Breed', _breed),
                const SizedBox(height: 10),
                _LabelField('Gender', _gender),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _vaccinated,
                      onChanged: (v) => setState(() => _vaccinated = v ?? false),
                    ),
                    const Text('Vaccinated'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _chipped,
                      onChanged: (v) => setState(() => _chipped = v ?? false),
                    ),
                    const Text('Chipped'),
                  ],
                ),
                const SizedBox(height: 6),
                _LabelField('Chip-Nr', _chipNr),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save/Add Pet'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  const _LabelField(this.label, this.controller);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Name'),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Bitte $label eingeben'
              : null,
        ),
      ],
    );
  }
}
