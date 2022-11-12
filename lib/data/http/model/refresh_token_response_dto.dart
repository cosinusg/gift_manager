// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_dto.g.dart';

@JsonSerializable()
class RefreshTokenResponseDto extends Equatable {
final String token;
final String refreshToken;

  RefreshTokenResponseDto({
    required this.token,
    required this.refreshToken,
  });

factory RefreshTokenResponseDto.fromJson(final Map<String, dynamic> json) => _$RefreshTokenResponseDtoFromJson(json);
Map<String, dynamic> toJson() => _$RefreshTokenResponseDtoToJson(this);

@override
List<Object?> get props => [token,refreshToken];
}
