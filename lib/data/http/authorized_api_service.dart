// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import 'package:gift_manager/data/http/base_api_service.dart';
import 'package:gift_manager/data/http/dio_provider.dart';
import 'package:gift_manager/data/http/model/api_error.dart';
import 'package:gift_manager/data/http/model/gifts_response_dto.dart';

class AuthorizedApiService extends BaseApiService {
  final Dio _dio;

  AuthorizedApiService(
    this._dio,
  );

  Future<Either<ApiError, GiftsResponseDto>> getAllGifts({
    final int limit = 10,
    final int offcet = 0,
  }) async {
    return responseOrError(
      () async {
        final response = await _dio.get(
          '/user/gifts',
          queryParameters: {
            'limit': limit,
            'offset': offcet,
          },
        );
        return GiftsResponseDto.fromJson(response.data);
      },
    );
  }

}
