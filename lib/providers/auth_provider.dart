import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../errors/api_response.dart';

class AuthProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
    ),
  );

  final _storage = const FlutterSecureStorage();

  Map<String, dynamic>? _user;
  bool _isAuthenticated = false;

  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  // Save auth credentials in local storage and update state
  Future<void> saveAuth(Map<String, dynamic> details) async {
    _user = details;
    _isAuthenticated = true;
    await _storage.write(key: 'auth', value: jsonEncode(details));
    notifyListeners();
  }

  // Get auth credentials from local storage
  Future<void> loadAuth() async {
    final storedAuth = await _storage.read(key: 'auth');
    if (storedAuth != null) {
      _user = jsonDecode(storedAuth);
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  // Clear local storage and update state
  Future<void> removeAuth() async {
    _user = null;
    _isAuthenticated = false;
    await _storage.deleteAll();
    notifyListeners();
  }

  // Sign Up Method
  Future<ApiResponse> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final signUpUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['signUpEndpoint']!;
      final response = await _dio.post(
        signUpUrl,
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        await saveAuth(response.data);
        return ApiResponse(statusCode: 200, message: 'Sign up successful');
      } else {
        return ApiResponse(
            statusCode: response.statusCode!, message: 'Sign up failed');
      }
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Sign up failed with error',
      );
    }
  }

  // Sign In Method
  Future<ApiResponse> signIn(String email, String password) async {
    try {
      final signInUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['signInEndpoint']!;
      final response = await _dio.post(
        signInUrl,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        await saveAuth(response.data);
        return ApiResponse(statusCode: 200, message: 'Sign in successful');
      } else {
        return ApiResponse(
            statusCode: response.statusCode!, message: 'Sign in failed');
      }
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Sign in failed with error',
      );
    }
  }

  // Google Sign-In Method
  Future<ApiResponse> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return ApiResponse(statusCode: 400, message: 'Google sign-in aborted');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final signInUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['googleSignInEndpoint']!;
      final response = await _dio.post(
        signInUrl,
        data: {'accessToken': accessToken},
      );
      if (response.statusCode == 200) {
        print(response.data);
        await saveAuth(response.data);
        return ApiResponse(
            statusCode: 200, message: 'Google sign-in successful');
      } else {
        return ApiResponse(
            statusCode: response.statusCode!, message: 'Google sign-in failed');
      }
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ??
            'Google sign-in failed with error',
      );
    }
  }

  // Logout Method
  Future<ApiResponse> logout() async {
    try {
      final storedAuth = await _storage.read(key: 'auth');
      if (storedAuth == null) {
        return ApiResponse(statusCode: 400, message: 'No auth token found!');
      }
      final user = jsonDecode(storedAuth);
      final logoutUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['logoutEndpoint']!;
      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';
      final response = await _dio.post(logoutUrl);

      if (response.statusCode == 200) {
        await removeAuth();
        return ApiResponse(statusCode: 200, message: 'Logged out successfully');
      } else {
        return ApiResponse(
            statusCode: response.statusCode!, message: 'Logout failed');
      }
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Logout failed with error',
      );
    }
  }
}
