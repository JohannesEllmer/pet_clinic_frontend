import 'package:flutter/material.dart';
import '../../../theme.dart';

class AppointmentDateTimeScreen extends StatefulWidget {
  const AppointmentDateTimeScreen({super.key});

  @override
  State<AppointmentDateTimeScreen> createState() => _AppointmentDateTimeScreenState();
}

class _AppointmentDateTimeScreenState extends State<AppointmentDateTimeScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) {
      setState(() => _selectedDate = d);
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (t != null) {
      setState(() => _selectedTime = t);
    }
  }

  void _save() {
    final dt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    Navigator.of(context).pop<DateTime>(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
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
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.panelBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select date", style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),

              // CALENDAR mockup-like
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      const Icon(Icons.calendar_month, size: 40, color: AppTheme.brandBlue),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Enter time", style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      const Icon(Icons.access_time, size: 40, color: AppTheme.brandBlue),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
