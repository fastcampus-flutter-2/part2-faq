import 'dart:convert';
import 'package:flutter/services.dart';

Future<dynamic> loadJsonData(String json) async {
  final String jsonString = await rootBundle.loadString('packages/tool_clind_network/$json');
  return jsonDecode(jsonString);
}