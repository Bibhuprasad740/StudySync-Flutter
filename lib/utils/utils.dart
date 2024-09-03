import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../errors/api_response.dart';

final Dio _dio = Dio();

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future<ApiResponse> fetchData(String apiEndpoint) async {
  try {
    final authController = AuthController();
    final storedAuth = await authController.getAuth();

    if (storedAuth == null) {
      return ApiResponse(statusCode: 400, message: 'No auth token found!');
    }

    final user = await jsonDecode(storedAuth);
    _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

    final response = await _dio.get(apiEndpoint);

    return ApiResponse(
      statusCode: 200,
      message: 'Success',
      data: response.data,
    );
  } on DioException catch (error) {
    return ApiResponse(
      statusCode: error.response?.statusCode ?? 500,
      message: error.response?.data['message'] ?? 'Sign up failed with error',
    );
  } catch (e) {
    return ApiResponse(
      statusCode: 500,
      message: 'An error occurred',
    );
  }
}
