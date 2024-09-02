import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../errors/api_response.dart';

class AuthController {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
  );

  final _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    // encryptedSharedPreferences: true,
    sharedPreferencesName: 'StudySync-Shared-Preferences',
    preferencesKeyPrefix: dotenv.env['SECURE_STORAGE_KEY'],
  ));

  // Save auth credentials in local storage
  Future<void> saveAuth(Map<String, dynamic> details) async {
    await _storage.write(key: 'auth', value: jsonEncode(details));
  }

  // Get auth credentials from local storage
  Future<String?> getAuth() async {
    return await _storage.read(key: 'auth');
  }

  // Clear local storage
  Future<void> removeAuth() async {
    await _storage.deleteAll();
  }

  // Sign Up Method
  Future<ApiResponse> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final signUpUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['signUpEndpoint']!;

      final response = await _dio.post(
        signUpUrl,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
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
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

  Future<ApiResponse> signIn(String email, String password) async {
    try {
      final signInUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['signInEndpoint']!;
      final response = await _dio.post(
        signInUrl,
        data: {
          'email': email,
          'password': password,
        },
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
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final storedAuth = await getAuth();
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
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

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
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

  // TODO: Add controller for sign up using google
}
