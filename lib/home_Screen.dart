import 'dart:convert';

import 'package:flutter/material.dart';
import 'android_version.dart';


class HomeScreen extends StatelessWidget {
  final String input1 = '[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';
  final String input2 = '[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Android Versions Parser'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[200]!, Colors.green[50]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoCard(),
                  SizedBox(height: 40),
                  _buildButton(context, 'Parse Input-1 Output', () => _showResult(context, input1)),
                  SizedBox(height: 20),
                  _buildButton(context, 'Parse Input-2 Output', () => _showResult(context, input2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.android, size: 50, color: Colors.green[700]),
            SizedBox(height: 16),
            Text(
              'Android Version Parser',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Select an input to parse Android version data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String input) {
    List<AndroidVersion> versions = parseJson(input);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parsed Android Versions', style: TextStyle(color: Colors.green[700])),
        content: Container(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: versions.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var version = versions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[200],
                  child: Text('${version.id}', style: TextStyle(color: Colors.green[700])),
                ),
                title: Text(version.title ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.green[700])),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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