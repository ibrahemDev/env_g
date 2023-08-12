

import 'dart:io';

import 'package:test/test.dart';
import 'env.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {


  group('Test args', () {
    test('test Normal int', () {
      expect(EnvNormal.testNormalBool1, true);
      expect(EnvNormal.testNormalBool2, false);

      expect(EnvNormal.testNormalInt1, 5987460);
      expect(EnvNormal.testNormalInt2, 651651);

      expect(EnvNormal.testNormalStr1, "dfgdgdsssssss000");
      expect(EnvNormal.testNormalStr2, "asdasdzzzzzzzqef");
    });
  });



  group('Test Genrated File', () {
    String data =  File(path.normalize('./test/normal/env.dart')).readAsStringSync();
    test('is Encrtypt lib not exists', () {
      expect(data.contains("import 'package:convert/convert.dart';"), false);
 
    });

    test('is not dev Mode', () {
       expect(data.contains("testNormalBool1 = true;"), false);
       expect(data.contains("5987460"), false);
       expect(data.contains("dfgdgdsssssss000"), false);
    });


    test('is not obfuscate', () {
      expect(data.contains("\"testNormalBool1\""), true);
      expect(data.contains("\"testNormalBool2\""), true);
      expect(data.contains("\"testNormalInt1\""), true);
      expect(data.contains("\"testNormalInt2\""), true);
      expect(data.contains("\"testNormalStr1\""), true);
      expect(data.contains("\"testNormalStr2\""), true);
    });


  });
  
}

