import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../errors/api_response.dart';
import 'auth_controller.dart';

class RevisionController {
  final _authController = AuthController();
  final _dio = Dio();

  Future<ApiResponse> updateRevision(String topicId) async {
    final storedAuth = await _authController.getAuth();
    if (storedAuth == null) {
      return ApiResponse(statusCode: 401, message: 'No credentials available!');
    }

    try {
      final user = await jsonDecode(storedAuth);

      final updateRevisionUrl =
          '${dotenv.env['BACKEND_BASE_URL']!}${dotenv.env['updateRevisionEndpoint']!}/$topicId';

      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';
      final response = await _dio.put(
        updateRevisionUrl,
      );

      return ApiResponse(statusCode: 200, message: response.data['message']);
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Something went wrong',
      );
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }
}
