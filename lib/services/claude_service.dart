import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/food_analysis.dart';

class ClaudeService {
  // flutter run --dart-define=CLAUDE_API_KEY=sk-ant-... ile çalıştırın
  static const String _apiKey =
      String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-opus-4-5';

  Future<FoodAnalysis> analyzeFood(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final ext = imagePath.split('.').last.toLowerCase();
    final mediaType = ext == 'png'
        ? 'image/png'
        : ext == 'webp'
            ? 'image/webp'
            : 'image/jpeg';

    final prompt = '''
Sen bir diyetisyen ve beslenme uzmanısın. Bu yemek fotoğrafını analiz et.

MUTLAKA aşağıdaki JSON formatında yanıt ver (başka hiçbir metin ekleme):

{
  "foods": [
    {
      "name": "Food Name in English",
      "name_tr": "Yemeğin Türkçe Adı",
      "portion": 150,
      "portion_unit": "g",
      "nutrients": {
        "calories": 320,
        "protein": 12.5,
        "carbs": 45.0,
        "fat": 8.5,
        "fiber": 3.2,
        "sugar": 5.1
      },
      "health_score": "İyi",
      "tags": ["protein", "tahıl"]
    }
  ],
  "total_nutrients": {
    "calories": 320,
    "protein": 12.5,
    "carbs": 45.0,
    "fat": 8.5,
    "fiber": 3.2,
    "sugar": 5.1
  },
  "summary": "Tabakta ne olduğunu Türkçe açıkla (1-2 cümle)",
  "advice": "Beslenme önerisi Türkçe (2-3 cümle)"
}

health_score değerleri: "Mükemmel", "İyi", "Orta", "Dikkatli"
Eğer yemek göremiyorsan calories: 0 yaz ve summary'de açıkla.
''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 2000,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mediaType,
                  'data': base64Image,
                },
              },
              {
                'type': 'text',
                'text': prompt,
              }
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API Hatası: ${response.statusCode} - ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    final content = responseData['content'][0]['text'] as String;

    // JSON parse
    final jsonStart = content.indexOf('{');
    final jsonEnd = content.lastIndexOf('}') + 1;
    final jsonStr = content.substring(jsonStart, jsonEnd);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    final foods = (data['foods'] as List<dynamic>)
        .map((f) => FoodItem.fromMap(Map<String, dynamic>.from(f)))
        .toList();

    final totalNutrients = NutrientInfo.fromMap(
        Map<String, dynamic>.from(data['total_nutrients'] ?? {}));

    return FoodAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      foods: foods,
      totalNutrients: totalNutrients,
      summary: data['summary'] ?? '',
      advice: data['advice'] ?? '',
      analyzedAt: DateTime.now(),
    );
  }
}
