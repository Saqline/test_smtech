import 'package:flutter/material.dart';
import 'package:test_app/android_version.dart';
import 'dart:convert';

class HomeScreen extends StatelessWidget {
  final String input1 = '[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';
  final String input2 = '[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Android Versions'),centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showResult(context, input1),
              child: Text('Show Input 1 Output'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showResult(context, input2),
              child: Text('Show Input 2 Output'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String input) {
    List<AndroidVersion> versions = parseJson(input);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parsed Android Versions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: versions
                .map((v) => Text('${v.id}: ${v.title}'))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  List<AndroidVersion> parseJson(String input) {
  List<AndroidVersion> result = [];
  
  dynamic decodedJson = json.decode(input);
  
  void processItem(dynamic item) {
    if (item is Map) {
      item.forEach((key, value) {
        if (value is Map && value.containsKey('id') && value.containsKey('title')) {
          result.add(AndroidVersion(id: value['id'], title: value['title']));
        }
      });
    } else if (item is List) {
      for (var subItem in item) {
        if (subItem is Map && subItem.containsKey('id') && subItem.containsKey('title')) {
          result.add(AndroidVersion(id: subItem['id'], title: subItem['title']));
        }
      }
    }
  }
  
  if (decodedJson is List) {
    for (var item in decodedJson) {
      processItem(item);
    }
  } else if (decodedJson is Map) {
    processItem(decodedJson);
  }
  
  return result;
}

}