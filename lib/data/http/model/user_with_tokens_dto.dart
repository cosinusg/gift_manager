// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:gift_manager/data/http/model/user_dto.dart';

part 'user_with_tokens_dto.g.dart';

@JsonSerializable()
class UserWithTokensDto extends Equatable {
  final String token;
  final String refreshToken;
  final UserDto user;

  UserWithTokensDto({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory UserWithTokensDto.fromJson(final Map<String, dynamic> json) => _$UserWithTokensDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserWithTokensDtoToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [token, refreshToken, user];

}
