import 'dart:convert';
import 'package:flutter/material.dart';

import '/security/api.dart';
import 'package:http/http.dart' as http;
Future<String?> getChatbotResponse(String userMessage) async {
  final url = Uri.parse('YOUR_API_ENDPOINT');

  final body = jsonEncode({
    "messages": [
      {"role": "user", "content": userMessage},
    ],
    "model": "YOUR_MODEL",
    "stream": false,
  });

  try {
    final response = await http.post(url, headers: Botkey.headers, body: body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final content = decoded['choices']?[0]?['message']?['content'];
      return content?.toString();
    } else {
      debugPrint('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    debugPrint('Exception: $e');
  }

  return null;
}
