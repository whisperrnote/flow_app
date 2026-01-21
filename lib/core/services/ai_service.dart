import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class AIService {
  static const String _baseUrl =
      'https://whisperrflow.vercel.app/api/ai'; // Placeholder URL

  Future<String> generateContent({
    required String prompt,
    List<Map<String, String>>? history,
    String? systemInstruction,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate'),
        headers: {
          'Content-Type': 'application/json',
          // Note: In a real app, you'd send the Appwrite session cookie or header
        },
        body: jsonEncode({
          'prompt': prompt,
          'history': history,
          'systemInstruction': systemInstruction,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'];
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'AI generation failed');
      }
    } catch (e) {
      throw Exception('AI Service Error: $e');
    }
  }
}
