// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gift_dto.g.dart';

@JsonSerializable()
class GiftDto extends Equatable {
final String id;
final String name;
final double? price;
final String? link;

  GiftDto({
    required this.id,
    required this.name,
    this.price,
    this.link,
  });

factory GiftDto.fromJson(final Map<String, dynamic> json) => _$GiftDtoFromJson(json);
Map<String, dynamic> toJson() => _$GiftDtoToJson(this);

@override
List<Object?> get props => [id,name,price,link];
}
