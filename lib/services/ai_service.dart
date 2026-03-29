import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import '../models/food_analysis.dart';
import '../widgets/portion_picker_sheet.dart';

class AIService {
  static String get _openaiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get _geminiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get _claudeKey => dotenv.env['CLAUDE_API_KEY'] ?? '';

  static String _buildPrompt({
    int? portionGrams,
    CookingMethod? cooking,
    Map<String, dynamic>? userProfile,
  }) {
    final lines = <String>[];
    if (portionGrams != null) lines.add('KULLANICI BİLGİSİ: Bu yemek yaklaşık $portionGrams gram.');
    if (cooking != null) lines.add('PİŞİRME YÖNTEMİ: ${cooking.promptText}.');
    if (userProfile != null && userProfile.isNotEmpty) {
      lines.add('KULLANICI PROFİLİ: ${_formatProfile(userProfile)}');
    }

    final contextBlock = lines.join('\n');

    return '''
Sen bir diyetisyen ve beslenme uzmanısın. Bu yemek fotoğrafını analiz et.
${contextBlock.isNotEmpty ? '\n$contextBlock\nBu bilgileri dikkate alarak DAHA DOĞRU kalori ve makro hesapla. Porsiyon verildiyse fotoğraftaki miktarı değil, belirtilen gramajı esas al.\n' : ''}
MUTLAKA aşağıdaki JSON formatında yanıt ver (başka hiçbir metin ekleme):

{
  "foods": [
    {
      "name": "Grilled Chicken",
      "name_tr": "Izgara Tavuk",
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

KURALLAR:
- name: İngilizce yemek adı — ne olduğunu anlatan, olabildiğince kısa isim. Gereksiz kelime ekleme, ama yemeği tam tanımlamak için gerekiyorsa uzun olabilir. Cümle değil, isim formatında yaz.
- name_tr: Türkçe yemek adı — aynı kural. Olabildiğince kısa, gerekirse uzun, isim formatında.
- Tabakta birden fazla yemek varsa her birini ayrı "foods" öğesi olarak yaz
- health_score değerleri: "Mükemmel", "İyi", "Orta", "Dikkatli"
- Eğer yemek göremiyorsan calories: 0 yaz ve summary'de açıkla.
''';
  }

  static String _formatProfile(Map<String, dynamic> p) {
    final parts = <String>[];
    if (p['age'] != null && p['age'] != 0) parts.add('${p['age']} yaşında');
    if (p['gender'] != null && p['gender'] != '') {
      parts.add(p['gender'] == 'male' ? 'erkek' : 'kadın');
    }
    if (p['weight'] != null && p['weight'] != 0) parts.add('${p['weight']}kg');
    if (p['height'] != null && p['height'] != 0) parts.add('${p['height']}cm');
    if (p['goal'] != null && p['goal'] != '') parts.add('hedef: ${p['goal']}');
    return parts.join(', ');
  }

  Future<FoodAnalysis> analyzeFood(
    String imagePath, {
    int? portionGrams,
    CookingMethod? cooking,
    Map<String, dynamic>? userProfile,
  }) async {
    final imageBytes = await _compressImage(imagePath);
    final base64Image = base64Encode(imageBytes);
    final mediaType = _mediaType(imagePath);
    final prompt = _buildPrompt(
      portionGrams: portionGrams,
      cooking: cooking,
      userProfile: userProfile,
    );

    if (_openaiKey.isNotEmpty) {
      try {
        return await _analyzeWithOpenAI(imagePath, base64Image, mediaType, prompt);
      } catch (_) {}
    }

    if (_geminiKey.isNotEmpty) {
      try {
        return await _analyzeWithGemini(imagePath, base64Image, mediaType, prompt);
      } catch (_) {}
    }

    if (_claudeKey.isNotEmpty) {
      return await _analyzeWithClaude(imagePath, base64Image, mediaType, prompt);
    }

    throw Exception('Hiçbir AI API key tanımlı değil.');
  }

  // ── OpenAI GPT-4o ──────────────────────────────────────────────────────────
  Future<FoodAnalysis> _analyzeWithOpenAI(
    String imagePath,
    String base64Image,
    String mediaType,
    String prompt,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openaiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'max_tokens': 2000,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mediaType;base64,$base64Image',
                  'detail': 'low',
                },
              },
              {'type': 'text', 'text': prompt},
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI Hatası: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;
    return _parse(imagePath, content);
  }

  // ── Gemini 2.5 Flash ───────────────────────────────────────────────────────
  Future<FoodAnalysis> _analyzeWithGemini(
    String imagePath,
    String base64Image,
    String mediaType,
    String prompt,
  ) async {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-04-17:generateContent?key=$_geminiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'inline_data': {
                  'mime_type': mediaType,
                  'data': base64Image,
                },
              },
              {'text': prompt},
            ],
          }
        ],
        'generationConfig': {'maxOutputTokens': 2000},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini Hatası: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['candidates'][0]['content']['parts'][0]['text'] as String;
    return _parse(imagePath, content);
  }

  // ── Claude (fallback) ──────────────────────────────────────────────────────
  Future<FoodAnalysis> _analyzeWithClaude(
    String imagePath,
    String base64Image,
    String mediaType,
    String prompt,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _claudeKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-haiku-4-5',
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
              {'type': 'text', 'text': prompt},
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude Hatası: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final content = data['content'][0]['text'] as String;
    return _parse(imagePath, content);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Future<List<int>> _compressImage(String imagePath) async {
    final result = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 800,
      minHeight: 800,
      quality: 70,
    );
    return result ?? await File(imagePath).readAsBytes();
  }

  String _mediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'png') return 'image/png';
    if (ext == 'webp') return 'image/webp';
    return 'image/jpeg';
  }

  FoodAnalysis _parse(String imagePath, String content) {
    final jsonStart = content.indexOf('{');
    final jsonEnd = content.lastIndexOf('}') + 1;
    final jsonStr = content.substring(jsonStart, jsonEnd);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    final foods = (data['foods'] as List)
        .map((f) => FoodItem.fromMap(Map<String, dynamic>.from(f)))
        .toList();

    final totalNutrients = NutrientInfo.fromMap(
      Map<String, dynamic>.from(data['total_nutrients'] ?? {}),
    );

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
