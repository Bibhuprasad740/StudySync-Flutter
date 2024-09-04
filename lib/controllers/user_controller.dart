import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_controller.dart';

class UserController {
  final Dio _dio = Dio();
  final _authController = AuthController();

  Future<void> ping() async {
    final storedAuth = await _authController.getAuth();
    if (storedAuth == null) {
      return;
    }
    try {
      final user = await jsonDecode(storedAuth);

      final pingUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['pingEngpoint']!;

      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

      await _dio.post(pingUrl);
    } on DioException catch (error) {
      print(error);
    } catch (e) {
      print('Ping failed: $e');
    }
  }
}
