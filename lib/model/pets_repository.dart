import '../../../core/result.dart';
import '../../../services/api_client.dart';
import '../../../services/api_config.dart';
import '../../../services/endpoints.dart';
import '../../../services/mockdata.dart';
import '../model/pet.dart';

class PetsRepository {
  PetsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  // In-Memory Fallback State (nur für Demo ohne Backend)
  static final List<Pet> _localPets = [...MockData.pets()];

  Future<Result<List<Pet>>> listPets() async {
    if (ApiConfig.useMockOnly) {
      return Result.success(List.unmodifiable(_localPets));
    }

    try {
      final res = await _api.get(Endpoints.pets);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res);
        final list = (data as List).cast<Map<String, dynamic>>();
        return Result.success(list.map(Pet.fromJson).toList());
      }
      return Result.failure('Pets laden fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        return Result.success(List.unmodifiable(_localPets));
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<Pet>> createPet(Pet pet) async {
    if (ApiConfig.useMockOnly) {
      final created = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: pet.name,
        type: pet.type,
        breed: pet.breed,
        gender: pet.gender,
        vaccinated: pet.vaccinated,
        chipped: pet.chipped,
        chipNr: pet.chipNr,
        diagnose: pet.diagnose,
        medication: pet.medication,
      );
      _localPets.insert(0, created);
      return Result.success(created);
    }

    try {
      final res = await _api.post(Endpoints.pets, body: pet.toJson());
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res) as Map<String, dynamic>;
        return Result.success(Pet.fromJson(data));
      }
      return Result.failure('Pet erstellen fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        final created = Pet(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: pet.name,
          type: pet.type,
          breed: pet.breed,
          gender: pet.gender,
          vaccinated: pet.vaccinated,
          chipped: pet.chipped,
          chipNr: pet.chipNr,
          diagnose: pet.diagnose,
          medication: pet.medication,
        );
        _localPets.insert(0, created);
        return Result.success(created);
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<Pet>> updatePet(Pet pet) async {
    if (ApiConfig.useMockOnly) {
      final idx = _localPets.indexWhere((p) => p.id == pet.id);
      if (idx >= 0) _localPets[idx] = pet;
      return Result.success(pet);
    }

    try {
      final res = await _api.put('${Endpoints.pets}/${pet.id}', body: pet.toJson());
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res) as Map<String, dynamic>;
        return Result.success(Pet.fromJson(data));
      }
      return Result.failure('Pet updaten fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        final idx = _localPets.indexWhere((p) => p.id == pet.id);
        if (idx >= 0) _localPets[idx] = pet;
        return Result.success(pet);
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deletePet(String id) async {
    if (ApiConfig.useMockOnly) {
      _localPets.removeWhere((p) => p.id == id);
      return Result.success(null);
    }

    try {
      final res = await _api.delete('${Endpoints.pets}/$id');
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Result.success(null);
      }
      return Result.failure('Pet löschen fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        _localPets.removeWhere((p) => p.id == id);
        return Result.success(null);
      }
      return Result.failure(e.toString());
    }
  }
}
