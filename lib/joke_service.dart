import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class JokeService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://v2.jokeapi.dev/joke';

  Future<List<Map<String, dynamic>>?> fetchJokesRaw(
      String? category, String? type, String? amount) async {
    if (amount == '') {
      return null;
    }
    try {
      // final SharedPreferences cache = await SharedPreferences.getInstance();
      final Response response;

      if (amount == '1') {
        response = await _dio.get('$baseUrl/$category', queryParameters: {
          // 'amount': null,
          'type': type,
          // 'blacklistFlag': flags,
        });
      }
      else {
        response = await _dio.get('$baseUrl/$category', queryParameters: {
          'amount': amount,
          'type': type,
          // 'blacklistFlag': flags,
        });
      }

      if (response.statusCode == 200) {
        if (response.data['error'] == true) {
          throw Exception(response.data['message'] ?? 'Failed to fetch jokes');
        }

        final List<dynamic> jokesJson = response.data['jokes'];
        // await cache.setString('cachedJokes', jsonEncode(jokesJson));
        return jokesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load jokes: ${response.statusCode}');
      }
    } catch (e) {
      // return fetchFromCache();
      throw Exception(e.toString());
    }
  }

  // Future<List<Map<String, dynamic>>?> fetchFromCache() async {
  //   final SharedPreferences cache = await SharedPreferences.getInstance();
  //   final String? cachedJokes = cache.getString('cachedJokes');
  //   if (cachedJokes != null) {
  //     final List<dynamic> jokesJson = jsonDecode(cachedJokes);
  //     return jokesJson.cast<Map<String, dynamic>>();
  //   }
  //   throw Exception("No cached jokes available for now...");
  // }

  // Future<bool> isConnected() async {
  //   final ConnectivityResult result = (await Connectivity().checkConnectivity()) as ConnectivityResult;
  //   return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  // }
}
