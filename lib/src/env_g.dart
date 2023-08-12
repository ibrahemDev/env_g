import 'package:env_g/src/loader.dart';
import 'package:env_g/src/builder.dart';

import 'package:path/path.dart' as path;

import 'models/config_model.dart';

class Envg {
  ///
  /// file path like ./pubspec.yaml
  /// or prod.env.yaml
  ///
  String inputPath;

  Envg({
    required this.inputPath,
  });

  Future<void> start() async {
    /// load
    ConfigModel configModel = await Loader.load(path.normalize(inputPath));
    Builder builder = Builder(this, configModel);

    /// build
    await builder.build();

    /// create files
    await builder.generateFiles();
  }
}
