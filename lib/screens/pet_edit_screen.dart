import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../model/pet.dart';
import '../model/pets_repository.dart';
import 'pet_form_screen.dart';

class PetEditScreen extends StatefulWidget {
  const PetEditScreen({super.key, required this.pet});
  final Pet pet;

  @override
  State<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final _repo = PetsRepository();

  Future<void> _edit() async {
    final changed = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PetFormScreen(pet: widget.pet)),
    );
    if (changed == true) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Soll "${widget.pet.name}" wirklich gelöscht werden?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final res = await _repo.deletePet(widget.pet.id);
    if (!mounted) return;

    if (res.isSuccess) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Fehler beim Löschen')),
      );
    }
  }

  Widget _panelBox({required Widget child, double height = 110}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Details"),
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
            children: [
              _panelBox(
                height: 40,
                child: Row(
                  children: const [
                    Expanded(child: Center(child: Text("Name"))),
                    Expanded(child: Center(child: Text("Type"))),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // NAME + TYPE ROW
              Row(
                children: [
                  Expanded(child: Text("Name:  ${pet.name}")),
                  Expanded(child: Text("Type:  ${pet.type}")),
                ],
              ),

              const SizedBox(height: 10),

              // Gender / Vaccination / Chipped
              Row(
                children: [
                  Expanded(child: Text("Gender: ${pet.gender}")),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(value: pet.vaccinated, onChanged: null),
                        const Text("Vaccinated"),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: pet.chipped, onChanged: null),
                  const Text("Chipped"),
                  const SizedBox(width: 10),
                  Expanded(child: Text("Chip-Nr: ${pet.chipNr}")),
                ],
              ),

              const SizedBox(height: 10),
              const Align(alignment: Alignment.centerLeft, child: Text("Diagnose")),
              const SizedBox(height: 8),

              _panelBox(
                height: 120,
                child: SingleChildScrollView(child: Text(pet.diagnose)),
              ),

              const SizedBox(height: 14),
              const Align(alignment: Alignment.centerLeft, child: Text("Medication/Treatment")),
              const SizedBox(height: 8),

              _panelBox(
                height: 120,
                child: SingleChildScrollView(child: Text(pet.medication)),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: _edit, icon: const Icon(Icons.edit, size: 28)),
                  const SizedBox(width: 20),
                  IconButton(onPressed: _delete, icon: const Icon(Icons.delete, size: 28, color: Colors.red)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
