import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';

class AuthService {
  // Base URL of the NestJS server
  static const String baseUrl = 'http://192.168.1.244:3000/auth';
  // Changed from const to final since FlutterSecureStorage() is not a const constructor
  static final storage = FlutterSecureStorage();

  // Login user and get token
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Login response status code: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody == null) {
          throw Exception('استجابة الخادم فارغة');
        }

        // Create a modified response that matches our expected LoginResponse structure
        final Map<String, dynamic> modifiedResponse = {
          'token': responseBody['accessToken'],
          'user': {
            'id': responseBody['user']['id'] ?? '',
            'name':
                '${responseBody['user']['firstName'] ?? ''} ${responseBody['user']['lastName'] ?? ''}'
                    .trim(),
            'email': responseBody['user']['email'] ?? '',
          }
        };

        final loginResponse = LoginResponse.fromJson(modifiedResponse);

        // Store token securely
        await storage.write(
            key: 'auth_token', value: responseBody['accessToken']);

        // Store refresh token if available
        if (responseBody['refreshToken'] != null) {
          await storage.write(
              key: 'refresh_token', value: responseBody['refreshToken']);
        }

        // Store user data
        await storage.write(
          key: 'user_data',
          value: json.encode(modifiedResponse['user']),
        );

        return loginResponse;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'فشل تسجيل الدخول';
        print('Login error: $errorMessage');
        print('Full error response: $errorData');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Login exception: ${e.toString()}');
      throw Exception('حدث خطأ أثناء الاتصال بالخادم: ${e.toString()}');
    }
  }

  // Register new user
  Future<LoginResponse> register(
      String email, String password, String firstName, String lastName) async {
    try {
      // Try a different endpoint - 'signup' is a common alternative to 'register'
      final url = '$baseUrl/register';
      print('Making registration request to: $url');
      print('Request body: ${jsonEncode({
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName
          })}');

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody == null) {
          throw Exception('استجابة الخادم فارغة');
        }

        // Create a modified response that matches our expected LoginResponse structure
        final Map<String, dynamic> modifiedResponse = {
          'token': responseBody['accessToken'],
          'user': {
            'id': responseBody['user']['id'] ?? '',
            'name':
                '${responseBody['user']['firstName'] ?? ''} ${responseBody['user']['lastName'] ?? ''}'
                    .trim(),
            'email': responseBody['user']['email'] ?? '',
          }
        };

        final loginResponse = LoginResponse.fromJson(modifiedResponse);

        // Store token securely
        await storage.write(
            key: 'auth_token', value: responseBody['accessToken']);

        // Store refresh token if available
        if (responseBody['refreshToken'] != null) {
          await storage.write(
              key: 'refresh_token', value: responseBody['refreshToken']);
        }

        // Store user data
        await storage.write(
          key: 'user_data',
          value: json.encode(modifiedResponse['user']),
        );

        return loginResponse;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'فشل إنشاء الحساب');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالخادم: ${e.toString()}');
    }
  }

  // Get current auth token
  static Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  // Get current user data
  static Future<User?> getCurrentUser() async {
    final userData = await storage.read(key: 'user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData) as Map<String, dynamic>);
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Logout user
  static Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_data');
  }
}
