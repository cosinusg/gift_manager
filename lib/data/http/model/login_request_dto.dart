// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto extends Equatable {
  final String email;
  final String password;
  LoginRequestDto({
    required this.email,
    required this.password,
  });

  factory LoginRequestDto.fromJson(final Map<String, dynamic> json) => _$LoginRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];

}
