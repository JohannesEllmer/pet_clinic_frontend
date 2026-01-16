import '../model/chat_message.dart';
import '../session_store.dart';
import 'api_client.dart';

class SupportApi {
  final ApiClient _api;
  final Session _session;

  SupportApi(this._api, this._session);

  Future<List<ChatMessage>> list() async {
    final j = await _api.getJson('/support/messages', token: _session.token);
    final arr = (j['messages'] ?? j['data'] ?? j ?? []) as List;
    return arr
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessage> send(String text) async {
    final j = await _api.postJson(
      '/support/messages',
      token: _session.token,
      body: {'text': text},
    );
    final out = (j['message'] ?? j) as Map<String, dynamic>;
    return ChatMessage.fromJson(out);
  }
}
