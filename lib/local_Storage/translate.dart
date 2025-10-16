import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
part 'translate.g.dart';

@HiveType(typeId: 1)
class Translate {

  @HiveField(0)
  String lang_inPut;
  
  @HiveField(1)
  String inPut;
  
   @HiveField(2)
  String outPut;
  
  @HiveField(3)
  String lang_output;

  @HiveField(4)
  Map<String, String> translations; 
  
  @HiveField(5)
  String matches;

    Translate({
    required this.lang_inPut,
    required this.inPut,
    required this.outPut,
    required this.lang_output,
    required this.translations,
    required this.matches,
  });
    
}