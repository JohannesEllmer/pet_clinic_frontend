import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../services/auth_repository.dart';
import '../../screens/pets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthRepository();

  bool _loading = true;
  String? _error;

  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  String _role = 'owner';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final res = await _auth.me();

    if (!mounted) return;

    if (res.isSuccess && res.data != null) {
      _first.text = res.data!.firstname;
      _last.text = res.data!.lastname;
      _phone.text = res.data!.phone;
      _role = res.data!.role;
    } else {
      _error = res.error;
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _managePets() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PetsScreen()));
  }

  void _save() {
    // Bridge: Hier würdest du ProfileRepository.update(...) nutzen,
    // wenn dein Backend update-Endpoint hat.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Save (Backend-Update hier einbauen)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.panelBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Firstname'),
                      Text('Lastname'),
                      Text('Phone'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Role', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Chip(label: Text(_role)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ProfileField(label: 'Firstname', controller: _first),
          const SizedBox(height: 10),
          _ProfileField(label: 'Lastname', controller: _last),
          const SizedBox(height: 10),
          _ProfileField(label: 'Phone Number', controller: _phone),
          const SizedBox(height: 10),
          _ProfileField(label: 'Address', controller: _address),
          const SizedBox(height: 10),
          _ProfileField(
            label: 'Pets',
            controller: TextEditingController(text: 'petname'),
            enabled: false,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 260,
            child: ElevatedButton(
              onPressed: _managePets,
              child: const Text('Tiere verwalten'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
      ],
    );
  }
}
