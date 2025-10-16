import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:task2/Api/translating.dart';
import 'package:get/get.dart';
import 'package:task2/local_Storage/translate.dart';
class TranslatingService {
  var output =''.obs; 
  var matches = <String>[].obs;
  
Future <Map <String,dynamic>?> showTranslated(String text,String fromLang,String toLang) async {
  try {
  final url='https://api.mymemory.translated.net/get';
  final dio=Dio();
  final resp=await dio.get(url,queryParameters: {
    'q':text,
    'langpair':'$fromLang|$toLang'
  } );
  if(resp.statusCode==200&& resp.data!=null){
    final data=resp.data;
    output.value=data['responseData']['translatedText'];
    List match = resp.data['matches'] as List;
      matches.value = match.map((m) => m['translation'].toString()??'').where((m) => m.isNotEmpty).toList();

return{
        'translation': output,
        'matches': matches,
      } ;
  }
  } catch(e){
    print('Error: $e');
  }
} 
  


}
  
Future<void> saveTranslationToHive({
  required String langInput,
  required String input,
  required String output,
  required String langOutput,
  required Map<String, String> translations,
  required String matches,
}) async {
  final box = Hive.box<Translate>('translationsBox');

  final newTranslation = Translate(
    lang_inPut: langInput,
    inPut: input,
    outPut: output,
    lang_output: langOutput,
    translations: translations,
    matches: matches,
  );

  await box.add(newTranslation);
  print('✅ تم حفظ الترجمة في Hive بنجاح!');
}