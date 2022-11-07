// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_tokens_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWithTokensDto _$UserWithTokensDtoFromJson(Map<String, dynamic> json) =>
    UserWithTokensDto(
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$UserWithTokensDtoToJson(UserWithTokensDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refresh_token': instance.refreshToken,
    };
