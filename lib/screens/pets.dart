import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../model/pets_repository.dart';
import '../model/pet.dart';
import 'pet_form_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final _repo = PetsRepository();
  late Future<List<Pet>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Pet>> _load() async {
    final res = await _repo.listPets();
    if (!res.isSuccess) throw Exception(res.error);
    return res.data ?? [];
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _openForm({Pet? pet}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PetFormScreen(pet: pet)),
    );
    if (changed == true) _refresh();
  }

  Future<void> _deletePet(Pet pet) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Delete "${pet.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    final res = await _repo.deletePet(pet.id);
    if (!mounted) return;

    if (res.isSuccess) {
      _refresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Fehler')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ WICHTIG: Scaffold => Material ancestor für Checkbox etc.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.panelBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder<List<Pet>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('${snap.error}'));
                      }

                      final pets = snap.data ?? [];
                      if (pets.isEmpty) {
                        return const Center(child: Text('Keine Pets vorhanden.'));
                      }

                      final selected = pets.first;

                      return Column(
                        children: [
                          _PetDetailPanel(
                            pet: selected,
                            onEdit: () => _openForm(pet: selected),
                            onDelete: () => _deletePet(selected),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black26),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: ListView.separated(
                                itemCount: pets.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (context, i) {
                                  final p = pets[i];
                                  return _PetRowCard(
                                    pet: p,
                                    onTap: () => _openForm(pet: p),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => _openForm(),
                  child: const Text('Add Pet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetDetailPanel extends StatelessWidget {
  const _PetDetailPanel({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  final Pet pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 44),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      border: Border.all(color: Colors.black45),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: _HeaderCell('Name')),
                        Expanded(child: _HeaderCell('Type')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  _kvRow('Name', pet.name),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(child: _kvRow('Gender', pet.gender)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            _tinyCheckbox(pet.vaccinated),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                'Vaccinated',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      _tinyCheckbox(pet.chipped),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Chipped',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Chip-Nr: ${pet.chipNr}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text('Diagnose'),
                  const SizedBox(height: 6),
                  _textBox(pet.diagnose),

                  const SizedBox(height: 10),
                  const Text('Medication/Treatment'),
                  const SizedBox(height: 6),
                  _textBox(pet.medication),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: AppTheme.brandBlue),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _tinyCheckbox(bool value) {
    return SizedBox(
      width: 26,
      height: 26,
      child: Checkbox(
        value: value,
        onChanged: null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _kvRow(String k, String v) {
    return Row(
      children: [
        Text('$k  ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(
            v,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _textBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.isEmpty ? '' : text,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _PetRowCard extends StatelessWidget {
  const _PetRowCard({required this.pet, required this.onTap});

  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.45),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // ✅ Text skaliert runter, statt Row zu sprengen
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(pet.name),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(pet.type),
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
                child: Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
