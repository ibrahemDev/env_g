// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_model.freezed.dart';
part 'env_model.g.dart';

//@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.pascal)
@Freezed(unionKey: 'type')
class EnvModel with _$EnvModel {
  @FreezedUnionValue('bool')
  const factory EnvModel.bool({
    @JsonKey(name: 'key', nullable: false) required String key,
    @JsonKey(name: 'value', nullable: false) required bool value,
    @JsonKey(name: 'encrypt', nullable: true) @Default(false) bool encrypt,
    @JsonKey(name: 'obfuscate', nullable: true) @Default(false) bool obfuscate,
  }) = EnvModelBool;

  @FreezedUnionValue('int')
  const factory EnvModel.int({
    @JsonKey(name: 'key', nullable: false) required String key,
    @JsonKey(name: 'value', nullable: false) required int value,
    @JsonKey(name: 'encrypt', nullable: true) @Default(false) bool encrypt,
    @JsonKey(name: 'obfuscate', nullable: true) @Default(false) bool obfuscate,
  }) = EnvModelInt;

  @FreezedUnionValue('String')
  const factory EnvModel.String({
    @JsonKey(name: 'key', nullable: false) required String key,
    @JsonKey(name: 'value', nullable: false) required String value,
    @JsonKey(name: 'encrypt', nullable: true) @Default(false) bool encrypt,
    @JsonKey(name: 'obfuscate', nullable: true) @Default(false) bool obfuscate,
  }) = EnvModelString;

  factory EnvModel.fromJson(Map<String, dynamic> json) => _$EnvModelFromJson(json);
}
