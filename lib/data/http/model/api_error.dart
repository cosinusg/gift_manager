// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/http/api_error_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError extends Equatable {
final dynamic code;
final String? message;
final String? error;

  const ApiError({
    required this.code,
    this.message,
    this.error,
  });

factory ApiError.fromJson(final Map<String, dynamic> json) => _$ApiErrorFromJson(json);
Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

ApiErrorType get errorType => ApiErrorType.getByCode(code);

@override
List<Object?> get props => [code, message, error];
}
