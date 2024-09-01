import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  Future<Response> signUp(
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
        return response;
      } else {
        throw Exception('Failed to sign up.');
      }
    } on DioException catch (error) {
      print('This is the error: ${error.response}');
      throw Exception(error.response?.data['message']);
    } catch (error) {
      rethrow;
    }
  }

  // Sign In Method
  Future<Response> signIn(String email, String password) async {
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
        return response;
      } else {
        throw Exception('Failed to sign in.');
      }
    } on DioException catch (error) {
      print('This is the error: ${error.response}');
      throw Exception(error.response?.data['message']);
    } catch (error) {
      rethrow;
    }
  }

  // Logout Method
  Future<void> logout() async {
    try {
      final storedAuth = await getAuth();
      if (storedAuth == null) {
        throw Exception('No auth token found!');
      }

      final user = jsonDecode(storedAuth);

      final logoutUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['logoutEndpoint']!;

      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

      final response = await _dio.post(
        logoutUrl,
      );

      if (response.statusCode == 200) {
        await removeAuth();
      } else {
        throw Exception('Failed to sign in.');
      }
    } on DioException catch (error) {
      print('This is the error: ${error.response}');
      throw Exception(error.response?.data['message']);
    } catch (e) {
      rethrow;
    }
  }

  // Google sign in
  Future<Response> googleSignIn() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // collect the access token from the response
      final accessToken = googleAuth.accessToken;

      final signInUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['googleSignInEndpoint']!;
      final response = await _dio.post(
        signInUrl,
        data: {'accessToken': accessToken},
      );

      if (response.statusCode == 200) {
        await saveAuth(response.data);
        return response;
      } else {
        throw Exception('Failed to sign in.');
      }

      // sign the user in using the email
    } on DioException catch (error) {
      print('This is the error: ${error.response}');
      throw Exception(error.response?.data['message']);
    } catch (error) {
      rethrow;
    }
  }
}
