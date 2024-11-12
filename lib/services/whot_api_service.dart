import 'dart:convert';

import '../constants.dart';
import 'package:validators/sanitizers.dart';
import "package:http/http.dart" as http;
import 'package:flutter/foundation.dart';

class WhotApiService {
  final baseUrl = "http$server_url/whot/";

  // // Helper function to construct the URL with parameters
  // Uri _url(String path, Map<String, dynamic> params) {
  //   final uri = Uri.parse(path);
  //   return uri.replace(queryParameters: params.isEmpty ? null : params);
  // }

  Uri _url(
    String path, [
    Map<String, dynamic> params = const {},
  ]) {
    String queryString = "";
    if (params.isNotEmpty) {
      queryString = "?";
      params.forEach(
        (k, v) {
          queryString += "$k=${v.toString()}&";
        },
      );
    }

    path = rtrim(path, '/');
    path = ltrim(path, '/');
    queryString = rtrim(queryString, '&');

    final url = '$baseUrl/$path/$queryString';
    return Uri.parse(url);
  }

  Future<Map<String, dynamic>> httpGet(
    String path, {
    Map<String, dynamic> params = const {},
  }) async {
    final url = _url(path, params);
    final response = await http.get(url);
    if (response.bodyBytes.isEmpty) {
      return {};
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List<dynamic>> httpGetList(
    String path, {
    Map<String, dynamic> params = const {},
  }) async {
    final url = _url(path, params);
    final response = await http.get(url);
    print(utf8.decode(response.bodyBytes));

    if (response.bodyBytes.isEmpty) {
      return [];
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> httpPost(
    String path, {
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? body,
  }) async {
    final url = _url(path, params);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.bodyBytes.isEmpty) {
      return {};
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> httpDelete(
    String path, {
    Map<String, dynamic> params = const {},
  }) async {
    final url = _url(path, params);
    final response = await http.delete(url);
    if (response.bodyBytes.isEmpty) {
      return {};
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
