import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:study_sync/controllers/auth_controller.dart';
import 'package:study_sync/errors/api_response.dart';

class StudyController {
  final _authController = AuthController();
  final _dio = Dio();

  Future<ApiResponse> addStudyData(
      String topic, String subject, String additionalInfo) async {
    final storedAuth = await _authController.getAuth();
    if (storedAuth == null) {
      return ApiResponse(statusCode: 401, message: 'No credentials available!');
    }

    try {
      final user = await jsonDecode(storedAuth);

      final addStudyDataUrl =
          dotenv.env['BACKEND_BASE_URL']! + dotenv.env['addStudyEndpoint']!;

      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

      final response = await _dio.post(addStudyDataUrl, data: {
        'topic': topic,
        'subject': subject,
        'additionalInfo': additionalInfo,
      });

      if (response.statusCode == 201) {
        return ApiResponse(statusCode: 200, message: response.data['message']);
      } else {
        return ApiResponse(
            statusCode: response.statusCode!, message: 'Adding data failed.');
      }
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Something went wrong.',
      );
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

  Future<ApiResponse> fetchStudyData() async {
    final storedAuth = await _authController.getAuth();
    if (storedAuth == null) {
      return ApiResponse(statusCode: 401, message: 'No credentials available!');
    }

    try {
      final user = await jsonDecode(storedAuth);
      final fetchStudyDataUrl = dotenv.env['BACKEND_BASE_URL']! +
          dotenv.env['getAllStudyDataEndpoint']!;

      _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

      final response = await _dio.get(fetchStudyDataUrl);

      return ApiResponse(
        statusCode: response.statusCode!,
        message: 'Data retrieved successfully',
        data: response.data,
      );
    } on DioException catch (error) {
      return ApiResponse(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data['message'] ?? 'Something went wrong.',
      );
    } catch (error) {
      return ApiResponse(statusCode: 500, message: 'Something went wrong');
    }
  }

  Future<ApiResponse> updateStudyData(
    String id,
    String topic,
    String subject,
    String additionalInfo,
  ) async {
    return ApiResponse(
      statusCode: 501, // Not implemented yet
      message: 'Updating data is not implemented yet.',
    );
  }
}
