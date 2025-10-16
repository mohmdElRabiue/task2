 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:task2/local_Storage/translate.dart';
import 'local_translatedScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;
  String? translatedText;
  late Box<Translate> _box;

  String sourceLang = 'auto';
  String targetLang = 'ar';

  final List<Map<String, String>> languages = [
    {"code": "en", "name": "English"},
    {"code": "ar", "name": "Arabic"},
    {"code": "fr", "name": "French"},
    {"code": "es", "name": "Spanish"},
  ];

  @override
  void initState() {
    super.initState();
    _openHiveBox();
  }

  Future<void> _openHiveBox() async {
    _box = await Hive.openBox<Translate>('translations');
  }

  Future<void> translateText(String text, String targetLang) async {
    if (text.isEmpty) return;
    setState(() {
      isLoading = true;
      translatedText = null;
    });

    try {
      final response = await Dio().post(
        'https://api.mymemory.translated.net/get',
        data: {
          'q': text,
          'source': sourceLang == 'auto' ? 'auto' : sourceLang,
          'target': targetLang,
          'format': 'text',
        },
        options: Options(headers: {'accept': 'application/json'}),
      );

      final translated = response.data['translatedText'] as String;

      // Save in Hive
      final newItem = Translate(
        lang_inPut: sourceLang,
        inPut: text,
        outPut: translated,
        lang_output: targetLang,
        translations: {targetLang: translated},
        matches: '',
      );

      await _box.add(newItem);

      setState(() {
        translatedText = translated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Translation saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          '🌍 Smart Translator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  LocalTranslatedScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter text to translate",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Type something here...",
                      filled: true,
                      fillColor: const Color(0xfff1f3f4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Language selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sourceLang,
                        items: [
                          const DropdownMenuItem(
                              value: 'auto', child: Text('Auto Detect')),
                          ...languages.map(
                            (lang) => DropdownMenuItem<String>(
                              value: lang['code'],
                              child: Text(lang['name']!),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => sourceLang = value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward_rounded, color: Colors.teal),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: targetLang,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => targetLang = value);
                          }
                        },
                        items: languages
                            .map(
                              (lang) => DropdownMenuItem<String>(
                                value: lang['code'],
                                child: Text(lang['name']!),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Translate button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        translateText(
                            textController.text.trim(), targetLang);
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.translate_rounded, color: Colors.white),
                label: Text(
                  isLoading ? "Translating..." : "Translate",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Show translated text
            if (translatedText != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Translated Text:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translatedText!,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
