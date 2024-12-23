import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heal_tether_task/core/exception/api_exception.dart';
import 'package:heal_tether_task/features/presentation/user_list/data/model/get_users_list_response.dart';

class GetUserListRepository {
  final Dio dio;

  GetUserListRepository({Dio? dio}) : dio = dio ?? Dio();

  Future<List<GetUsersListResponse>> getUsersList() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/users');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final List<GetUsersListResponse> usersList = (response.data as List)
              .map((e) => GetUsersListResponse.fromJson(e))
              .toList();

          log('Users list fetched successfully: ${usersList.length} users');
          return usersList;
        } catch (e) {
          log('Error parsing response data: $e');
          throw ApiException(
            message: 'Failed to parse users data',
            error: e,
          );
        }
      } else {
        log('API returned error status code: ${response.statusCode}');
        throw ApiException(
          message: 'Failed to load users list',
          statusCode: response.statusCode,
          error: response.data,
        );
      }
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
      throw ApiException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      log('Unexpected error occurred: $e');
      throw ApiException(
        message: 'Unexpected error occurred',
        error: e,
      );
    }
  }
}

final getUserListRepositoryProvider = Provider<GetUserListRepository>((ref) {
  return GetUserListRepository();
});
