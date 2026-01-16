import '../model/appointment.dart';
import '../session_store.dart';
import 'api_client.dart';

class AppointmentsApi {
  final ApiClient _api;
  final Session _session;

  AppointmentsApi(this._api, this._session);

  Future<List<Appointment>> list() async {
    final j = await _api.getJson('/appointments', token: _session.token);
    final arr = (j['appointments'] ?? j['data'] ?? j ?? []) as List;
    return arr
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> create(Appointment a) async {
    final j = await _api.postJson(
      '/appointments',
      token: _session.token,
      body: a.toJson(),
    );
    final out = (j['appointment'] ?? j) as Map<String, dynamic>;
    return Appointment.fromJson(out);
  }
}
