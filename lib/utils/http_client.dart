import 'package:dio/dio.dart';

class HttpClient {
  static HttpClient? _instance;
  late Dio _dio;

  HttpClient._internal() {
    _dio = Dio();
  }

  factory HttpClient() {
    if (_instance == null) {
      _instance = HttpClient._internal();
    }
    return _instance!;
  }

  Future<Response?> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } catch (error) {
      print('GET request error: $error');
      return null;
    }
  }

  Future<Response?> post(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (error) {
      print('POST request error: $error');
      return null;
    }
  }

  Future<Response?> put(String url, dynamic data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } catch (error) {
      print('PUT request error: $error');
      return null;
    }
  }

  Future<Response?> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return response;
    } catch (error) {
      print('DELETE request error: $error');
      return null;
    }
  }
}
