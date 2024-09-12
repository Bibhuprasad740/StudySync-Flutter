import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../errors/api_response.dart';
import '../providers/auth_provider.dart';

final Dio _dio = Dio();

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future<ApiResponse> fetchData(BuildContext context, String apiEndpoint) async {
  try {
    // Get the AuthProvider instance
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch the storedAuth (auth token) from the AuthProvider
    final user = authProvider.user;

    if (user == null) {
      return ApiResponse(statusCode: 400, message: 'No auth token found!');
    }

    // Set the authorization header
    _dio.options.headers['authorization'] = 'Bearer ${user['token']}';

    // Make the API call
    final response = await _dio.get(apiEndpoint);

    return ApiResponse(
      statusCode: 200,
      message: 'Success',
      data: response.data,
    );
  } on DioException catch (error) {
    return ApiResponse(
      statusCode: error.response?.statusCode ?? 500,
      message: error.response?.data['message'] ?? 'Request failed with error',
    );
  } catch (e) {
    return ApiResponse(
      statusCode: 500,
      message: 'An error occurred',
    );
  }
}
