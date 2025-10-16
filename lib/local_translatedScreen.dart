import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:task2/Api/translating.dart';
import 'package:task2/Api/translating_service.dart';
import 'package:task2/local_Storage/translate.dart';
class LocalTranslatedScreen extends StatelessWidget {
   LocalTranslatedScreen({Key? key}) ;
  final TranslatingService service = TranslatingService();
  final RxList<Translate> translatings = <Translate>[].obs;
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Local Translated Screen'),
      ),
      body: Column (
        children: 
        [
         Expanded(
              child: Obx(() => translatings.isNotEmpty
                  ? ListView.builder(
                      itemCount: translatings.length,
                      // cacheExtent: 400,
                      // prototypeItem: Text(
                      //   '',
                      //   style: TextStyle(fontSize: 34),
                      // ),
                      itemBuilder: (ctx, index) => ListTile(
                            leading: Text(
                              translatings[index].inPut,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Text(
                              translatings[index].outPut.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                          ))
                  : Text('no data')), 
        
      ),
        ],
      ),  
    ) ;  
  
}}