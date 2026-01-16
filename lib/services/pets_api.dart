import '../model/pet.dart';
import '../session_store.dart';
import 'api_client.dart';

class PetsApi {
  final ApiClient _api;
  final Session _session;

  PetsApi(this._api, this._session);

  Future<List<Pet>> list() async {
    final j = await _api.getJson('/pets', token: _session.token);
    final arr = (j['pets'] ?? j['data'] ?? j ?? []) as List;
    return arr
        .map((e) => Pet.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> create(Pet p) async {
    final j = await _api.postJson(
      '/pets',
      token: _session.token,
      body: p.toJson(),
    );
    final out = (j['pet'] ?? j) as Map<String, dynamic>;
    return Pet.fromJson(out);
  }

  Future<Pet> update(Pet p) async {
    final j = await _api.putJson(
      '/pets/${p.id}',
      token: _session.token,
      body: p.toJson(),
    );
    final out = (j['pet'] ?? j) as Map<String, dynamic>;
    return Pet.fromJson(out);
  }

  Future<void> delete(String id) async {
    await _api.deleteJson('/pets/$id', token: _session.token);
  }
}
