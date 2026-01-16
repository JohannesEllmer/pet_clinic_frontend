import '../../../core/result.dart';
import '../../../services/api_client.dart';
import '../../../services/api_config.dart';
import '../../../services/endpoints.dart';
import '../../../services/mockdata.dart';
import '../model/chat_message.dart';

class SupportRepository {
  SupportRepository({ApiClient? api}) : _api = api ?? ApiClient();
  final ApiClient _api;

  static final List<ChatMessage> _local = [...MockData.supportMessages()];

  Future<Result<List<ChatMessage>>> list() async {
    if (ApiConfig.useMockOnly) {
      return Result.success(List.unmodifiable(_local));
    }

    try {
      final res = await _api.get(Endpoints.supportMessages);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res);
        final list = (data as List).cast<Map<String, dynamic>>();
        return Result.success(list.map(ChatMessage.fromJson).toList());
      }
      return Result.failure('Support laden fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        return Result.success(List.unmodifiable(_local));
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<ChatMessage>> send(String text) async {
    if (ApiConfig.useMockOnly) {
      final userMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        fromUser: true,
        createdAt: DateTime.now(),
      );
      _local.add(userMsg);

      // Optional: Auto-Antwort Support
      _local.add(ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}-bot',
        text: 'Danke! Wir melden uns so schnell wie möglich.',
        fromUser: false,
        createdAt: DateTime.now(),
      ));

      return Result.success(userMsg);
    }

    try {
      final res = await _api.post(Endpoints.supportMessages, body: {'text': text});
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res) as Map<String, dynamic>;
        return Result.success(ChatMessage.fromJson(data));
      }
      return Result.failure('Senden fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        final userMsg = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          fromUser: true,
          createdAt: DateTime.now(),
        );
        _local.add(userMsg);
        return Result.success(userMsg);
      }
      return Result.failure(e.toString());
    }
  }
}
