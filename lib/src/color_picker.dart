// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';

// void test() {
//   // ColorDict.sources.
//   // Review: This here instead of displaying the ColorDict.sources should automatically display the available list of sources.
// }

// class ColorDict {
//   /// this will have values from the json.

// }

// // pending list: String color, String shades, String hex
// void createColor(String source) async {
//   Color color =
//       Color(source: 'w3schools', name: 'Blue', shade: 'dark', hex: '001234567');

//   writeToFile(color.toString());
// }

// class Color {
//   String source;
//   String name;
//   String shade;
//   String hex;

//   Color({this.source, this.name, this.shade, this.hex});

//   Map toJson() {
//     return {
//       'source': source,
//       'name': name,
//       'shade': shade,
//       'hex': hex,
//     };
//   }

//   @override
//   String toString() {
//     return '$source, $name, $shade, $hex';
//   }
// }

// void writeToFile(String data) async {
//   final String filename = 'colors.json';
//   await rootBundle.load('assets/docs/colors.json').then((f){
//     print("file loaded successfully.");
//     File file = File(filename);
//     file.writeAsString(data);
//   });
// }
