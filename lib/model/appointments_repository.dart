import '../../../core/result.dart';
import '../../../services/api_client.dart';
import '../../../services/api_config.dart';
import '../../../services/endpoints.dart';
import '../../../services/mockdata.dart';
import '../model/appointment.dart';

class AppointmentsRepository {
  AppointmentsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  static final List<Appointment> _local = [...MockData.appointments()];

  Future<Result<List<Appointment>>> list() async {
    if (ApiConfig.useMockOnly) {
      return Result.success(List.unmodifiable(_local));
    }

    try {
      final res = await _api.get(Endpoints.appointments);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res);
        final list = (data as List).cast<Map<String, dynamic>>();
        return Result.success(list.map(Appointment.fromJson).toList());
      }
      return Result.failure('Appointments laden fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        return Result.success(List.unmodifiable(_local));
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<Appointment>> create(Appointment a) async {
    if (ApiConfig.useMockOnly) {
      final created = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        petId: a.petId,
        petName: a.petName,
        type: a.type,
        vet: a.vet,
        issue: a.issue,
        dateTime: a.dateTime,
      );
      _local.insert(0, created);
      return Result.success(created);
    }

    try {
      final res = await _api.post(Endpoints.appointments, body: a.toJson());
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res) as Map<String, dynamic>;
        return Result.success(Appointment.fromJson(data));
      }
      return Result.failure('Appointment speichern fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        final created = Appointment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          petId: a.petId,
          petName: a.petName,
          type: a.type,
          vet: a.vet,
          issue: a.issue,
          dateTime: a.dateTime,
        );
        _local.insert(0, created);
        return Result.success(created);
      }
      return Result.failure(e.toString());
    }
  }
}
