import 'dart:io';
import 'package:dart_style/dart_style.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:env_g/src/utiles.dart';
import 'package:env_g/src/env_g.dart';
import 'package:tuple/tuple.dart';
import 'package:path/path.dart' as path;

import 'models/env_model.dart';
import 'models/config_model.dart';

class Builder {
  //static final RandomGen randomGen = RandomGen();
  //static final HexUtile hexUtile = HexUtile();
  final ConfigModel configModel;
  final Envg envg;

  StringBuffer contentForDartCode = StringBuffer();
  StringBuffer? contentForDartDefinesFile;
  StringBuffer? contentForFlutterDefinesFile;
  List<Tuple2<String, String>> envs = [];
  Builder(this.envg, this.configModel);

  build() async {
    if (!configModel.isDevMode && configModel.envsList.any((element) => element.encrypt)) {
      contentForDartCode.writeln("import 'package:encrypt/encrypt.dart' as Encrypt;");
      contentForDartCode.writeln("import 'package:convert/convert.dart';");
    }

    contentForDartCode.writeln("class ${configModel.className} {");
    contentForDartCode.writeln("static final ${configModel.className} _instance = ${configModel.className}._internal();");

    /// need this section to use [envsListNonEncript] before constractor and [envsListEncript] aftre
    List<EnvModel> envsListNonEncript = configModel.envsList.where((element) => element.encrypt == false).toList();
    List<EnvModel> envsListEncript = configModel.envsList.where((element) => element.encrypt == true).toList();

    //

    for (int i = 0; i < envsListNonEncript.length; i++) {
      EnvModel env = envsListNonEncript[i];
      if (configModel.isDevMode) {
        await _buildEnvDev(env);
      } else {
        if (env.obfuscate) {
          _buildeEnvObfuscate(env);
        } else {
          _buildeEnvNormal(env);
        }
      }
    }

    contentForDartCode.writeln("${configModel.className}._internal();");
    contentForDartCode.writeln("factory ${configModel.className}(){");
    contentForDartCode.writeln(" return _instance;");
    contentForDartCode.writeln("}");

    if (!configModel.isDevMode && configModel.envsList.any((element) => element.encrypt)) {
      contentForDartCode.writeln("String _decrypt(String secretKey,String encryptedBase64, Encrypt.IV iv){");
      contentForDartCode.writeln("final key = Encrypt.Key.fromUtf8(secretKey);");
      contentForDartCode.writeln("late final encrypter = Encrypt.Encrypter(Encrypt.AES(key, mode: Encrypt.AESMode.cfb64));");
      contentForDartCode.writeln("late final value = encrypter.decrypt64(encryptedBase64,iv: iv);");
      contentForDartCode.writeln("return value;");
      contentForDartCode.writeln("}");
      contentForDartCode.writeln("String hexToBase64(String val){");
      contentForDartCode.writeln("return String.fromCharCodes(hex.decode(val));");
      contentForDartCode.writeln("}");
    }

    for (int i = 0; i < envsListEncript.length; i++) {
      EnvModel env = envsListEncript[i];
      if (configModel.isDevMode) {
        await _buildEnvDev(env);
      } else {
        if (env.obfuscate) {
          _buildeEnvMix(env);
        } else {
          _buildeEnvEncrypt(env);
        }
      }
    }

    contentForDartCode.writeln("}");

    if (!configModel.isDevMode) {
      if (configModel.createDartDefinesFile || configModel.createFlutterDefinesFile) {
        if (configModel.createDartDefinesFile) {
          contentForDartDefinesFile = StringBuffer();
        }

        if (configModel.createFlutterDefinesFile) {
          contentForFlutterDefinesFile = StringBuffer();
        }

        for (int i = 0; i < envs.length; i++) {
          contentForDartDefinesFile?.write(' --define=${envs[i].item1}=${envs[i].item2}');
          contentForFlutterDefinesFile?.write(' --dart-define=${envs[i].item1}=${envs[i].item2}');
        }
      }
    }
  }

  _buildeEnvNormal(EnvModel env) {
    if (env is EnvModelBool) {
      contentForDartCode.writeln('static const bool ${env.key} = bool.fromEnvironment("${env.key}");');
    } else if (env is EnvModelString) {
      contentForDartCode.writeln('static const String ${env.key} = String.fromEnvironment("${env.key}");');
    } else if (env is EnvModelInt) {
      contentForDartCode.writeln('static const int ${env.key} = int.fromEnvironment("${env.key}");');
    }

    envs.add(Tuple2.fromList([env.key, env.value.toString()]));
  }

  _buildeEnvObfuscate(EnvModel env) {
    String obfuscateKey = Utiles.getRandomKey();
    if (env is EnvModelBool) {
      contentForDartCode.writeln('static const bool ${env.key} = bool.fromEnvironment("$obfuscateKey");');
    } else if (env is EnvModelString) {
      contentForDartCode.writeln('static const String ${env.key} = String.fromEnvironment("$obfuscateKey");');
    } else if (env is EnvModelInt) {
      contentForDartCode.writeln('static const int ${env.key} = int.fromEnvironment("$obfuscateKey");');
    }

    envs.add(Tuple2.fromList([obfuscateKey, env.value.toString()]));
  }

  _buildeEnvEncrypt(EnvModel env) {
    String secretKey = Utiles.getRandomPass();
    String ivStr = Utiles.getRandomString(16);
    encrypt.IV iv = encrypt.IV.fromUtf8(ivStr);
    //
    final key = encrypt.Key.fromUtf8(secretKey);
    late final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cfb64));

    String encryptedBase64 = Utiles.base64ToHex(encrypter.encrypt(env.value.toString(), iv: iv).base64);

    if (env is EnvModelBool) {
      contentForDartCode.writeln('bool? _${env.key};');
      contentForDartCode.writeln('bool get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');

      contentForDartCode.writeln('String cache = _decrypt("$secretKey" ,hexToBase64(const String.fromEnvironment("${env.key}")), Encrypt.IV.fromUtf8("$ivStr"));');
      contentForDartCode.writeln('_${env.key} = cache == "true" ? true : cache == "false" ? false : false;');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
    } else if (env is EnvModelString) {
      contentForDartCode.writeln('String? _${env.key};');
      contentForDartCode.writeln('String get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');

      contentForDartCode.writeln('_${env.key} = _decrypt("$secretKey" ,hexToBase64(const String.fromEnvironment("${env.key}")), Encrypt.IV.fromUtf8("$ivStr"));');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
    } else if (env is EnvModelInt) {
      contentForDartCode.writeln('int? _${env.key};');
      contentForDartCode.writeln('int get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
      contentForDartCode.writeln('String cache = _decrypt("$secretKey" ,hexToBase64(const String.fromEnvironment("${env.key}")), Encrypt.IV.fromUtf8("$ivStr"));');

      contentForDartCode.writeln('_${env.key} = int.tryParse(cache ) ?? -1;');
      contentForDartCode.writeln('return _${env.key}!;');

      contentForDartCode.writeln('}');
    }

    envs.add(Tuple2.fromList([env.key, encryptedBase64]));
  }

  _buildeEnvMix(EnvModel env) {
    String obfuscateKey1 = Utiles.getRandomKey();
    String obfuscateKey2 = Utiles.getRandomKey();
    String secretKey = Utiles.getRandomPass();
    Tuple2<String, String> secretKeySplited = splitStr2Part(secretKey);
    String ivStr = Utiles.getRandomString(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(secretKey), mode: encrypt.AESMode.cfb64));

    String encryptedVal = encrypter.encrypt(env.value.toString(), iv: encrypt.IV.fromUtf8(ivStr)).base64;
    Tuple2<String, String> encryptedSplited = splitStr2Part(encryptedVal);

    if (env is EnvModelBool) {
      contentForDartCode.writeln('bool? _${env.key};');
      contentForDartCode.writeln('bool get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');

      //hexToBase64(const String.fromEnvironment("$obfuscateKey1")) + "${secretKeySplited.item2}"

      //"${hexToBase64(const String.fromEnvironment("$obfuscateKey2"))}${encryptedSplited.item2}"
      //hexToBase64(const String.fromEnvironment("$obfuscateKey2")) + "${encryptedSplited.item2}";
      contentForDartCode.writeln('String cache = _decrypt("\${hexToBase64(const String.fromEnvironment("$obfuscateKey1"))}${secretKeySplited.item2}" ,"\${hexToBase64(const String.fromEnvironment("$obfuscateKey2"))}${encryptedSplited.item2}", Encrypt.IV.fromUtf8("$ivStr"));');
      contentForDartCode.writeln('_${env.key} = cache == "true" ? true : cache == "false" ? false : false;');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
    } else if (env is EnvModelString) {
      contentForDartCode.writeln('String? _${env.key};');
      contentForDartCode.writeln('String get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
      contentForDartCode.writeln('_${env.key} = _decrypt("\${hexToBase64(const String.fromEnvironment("$obfuscateKey1"))}${secretKeySplited.item2}" ,"\${hexToBase64(const String.fromEnvironment("$obfuscateKey2"))}${encryptedSplited.item2}", Encrypt.IV.fromUtf8("$ivStr"));');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
    } else if (env is EnvModelInt) {
      contentForDartCode.writeln('int? _${env.key};');
      contentForDartCode.writeln('int get ${env.key} {');
      contentForDartCode.writeln('if(_${env.key} != null){');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
      contentForDartCode.writeln('String cache = _decrypt("\${hexToBase64(const String.fromEnvironment("$obfuscateKey1"))}${secretKeySplited.item2}" ,"\${hexToBase64(const String.fromEnvironment("$obfuscateKey2"))}${encryptedSplited.item2}", Encrypt.IV.fromUtf8("$ivStr"));');
      contentForDartCode.writeln('int? intCache = int.tryParse(cache);');
      contentForDartCode.writeln('if(intCache == null){');
      contentForDartCode.writeln('throw "${env.key} env tryParse not int";');
      contentForDartCode.writeln('}');
      contentForDartCode.writeln('_${env.key} = intCache;');
      contentForDartCode.writeln('return _${env.key}!;');
      contentForDartCode.writeln('}');
    }

    envs.add(Tuple2.fromList([obfuscateKey1, Utiles.base64ToHex(secretKeySplited.item1)]));
    envs.add(Tuple2.fromList([obfuscateKey2, Utiles.base64ToHex(encryptedSplited.item1)]));
  }

  _buildEnvDev(EnvModel env) {
    if (env is EnvModelBool) {
      if (env.encrypt) {
        contentForDartCode.writeln('bool get ${env.key} => ${env.value};');
      } else {
        contentForDartCode.writeln("static const bool ${env.key} = ${env.value ? 'true' : 'false'};");
      }
    } else if (env is EnvModelString) {
      if (env.encrypt) {
        contentForDartCode.writeln('String get ${env.key} => "${env.value}";');
      } else {
        contentForDartCode.writeln('static const String ${env.key} = "${env.value}";');
      }
    } else if (env is EnvModelInt) {
      if (env.encrypt) {
        contentForDartCode.writeln('int get ${env.key} => ${env.value};');
      } else {
        contentForDartCode.writeln('static const int ${env.key} = ${env.value};');
      }
    }
  }

  Tuple2<String, String> splitStr2Part(String str) {
    List<String> s = str.split('');


    ///
    ///(s.length / 2).toInt()  ==  s.length ~/ 2
    ///
    String item1 = s.sublist(0, s.length ~/ 2 ).join();
    s.removeRange(0, s.length ~/ 2);

    String item2 = s.join();
    return Tuple2.fromList([item1, item2]);
    //Tuple2.fromList([substring(0, this.length), substring(this.length)]);
  }

  String _dartFormat(String content) {
    try {
      var formatter = DartFormatter();
      return formatter.format(content);
    } catch (e) {
      return content;
    }
  }

  generateFiles() {
    if (!configModel.isDevMode) {
      if (contentForDartDefinesFile != null) {
        File dartDefinesFile = File(path.normalize(path.join(path.dirname(envg.inputPath), configModel.dartDefinesFileOutputPath)));
        dartDefinesFile.writeAsStringSync(contentForDartDefinesFile.toString());
      }

      if (contentForFlutterDefinesFile != null) {
        File flutterDefinesFile = File(path.normalize(path.join(path.dirname(envg.inputPath), configModel.flutterDefinesFileOutputPath)));
        flutterDefinesFile.writeAsStringSync(contentForFlutterDefinesFile.toString());
      }
    }

    final envDartStr = _dartFormat(contentForDartCode.toString());
    File envDartOutput = File(path.normalize(path.join(path.dirname(envg.inputPath), configModel.outputPath)));
    envDartOutput.writeAsStringSync(envDartStr);
  }
}
