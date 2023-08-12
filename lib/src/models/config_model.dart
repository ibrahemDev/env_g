// ignore_for_file: deprecated_member_use

import 'env_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';



@freezed
class ConfigModel with _$ConfigModel {
  const ConfigModel._();
  const factory ConfigModel({
    @JsonKey(name: 'envs', fromJson: envsFromJson, nullable: false) required Map<String, EnvModel> envs,
    @JsonKey(name: 'createDartDefinesFile', nullable: true) @Default(false) bool createDartDefinesFile,
    @JsonKey(name: 'createFlutterDefinesFile', nullable: true) @Default(false) bool createFlutterDefinesFile,
    @JsonKey(name: 'isDevMode', nullable: true) @Default(false) bool isDevMode,
    @JsonKey(name: 'className', nullable: true) @Default("Env") String className,
    @JsonKey(name: 'outputPath', nullable: false) required String outputPath,
    @JsonKey(name: 'dartDefinesFileOutputPath', nullable: true) @Default("./.dart-defines") String dartDefinesFileOutputPath,
    @JsonKey(name: 'flutterDefinesFileOutputPath', nullable: true) @Default("./.flutter-defines") String flutterDefinesFileOutputPath,
  }) = _ConfigModel;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => _$ConfigModelFromJson(json);

  List<EnvModel> get envsList {
    return envs.values.toList();
  }
}

Map<String, EnvModel> envsFromJson(Map<String, dynamic> json) {
  List<String> keysList = json.keys.toList();
  Map<String, EnvModel> newMap = {};
  for (int i = 0; i < keysList.length; i++) {
    json[keysList[i]]['type'] = json[keysList[i]]['value'].runtimeType.toString();
    json[keysList[i]]['key'] = keysList[i];
    newMap[keysList[i]] = EnvModel.fromJson(json[keysList[i]]);
  }
  return newMap;
}
