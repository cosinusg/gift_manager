// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_with_tokens_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserWithTokensDto extends Equatable {
  final String token;
  final String refreshToken;

  UserWithTokensDto({
    required this.token,
    required this.refreshToken,
  });

  factory UserWithTokensDto.fromJson(final Map<String, dynamic> json) => _$UserWithTokensDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserWithTokensDtoToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [token, refreshToken];

}
