// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto extends Equatable {
final String id;
final String name;
final String email;
final String avatarUrl;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

factory UserDto.fromJson(final Map<String, dynamic> json) => _$UserDtoFromJson(json);
Map<String, dynamic> toJson() => _$UserDtoToJson(this);

@override
List<Object?> get props => [id, name, email, avatarUrl];
}
