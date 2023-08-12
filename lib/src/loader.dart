import 'dart:io';
import 'package:env_g/src/extensions.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'models/config_model.dart';

class Loader {
  static Future<ConfigModel> load(String filePath) async {
    String filePathNormalize = path.normalize(filePath);
    if (path.extension(filePathNormalize) != '.yaml') {
      throw 'Loader: only suport yaml files';
    }

    String data = File(filePathNormalize).readAsStringSync();
    Map<String, dynamic> map = (await loadYaml(data) as YamlMap).toMap();
    return ConfigModel.fromJson(map);
  }
}
