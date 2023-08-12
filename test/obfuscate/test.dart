

import 'dart:io';

import 'package:test/test.dart';
import 'env.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {


  group('Test args', () {
    test('test Str', () {
      expect(EnvObfuscate.testStr1, "dfgdgdsssssss000");
      expect(EnvObfuscate.testStr2, "asdasdzzzzzzzqef");
    });
    test('test bool', () {
      expect(EnvObfuscate.testBool1, true);
      expect(EnvObfuscate.testBool2, false);
    });
    test('test int', () {
      

      expect(EnvObfuscate.testInt1, 5987460);
      expect(EnvObfuscate.testInt2, 651651);

      
    });
  });



  group('Test Genrated File', () {
    String data =  File(path.normalize('./test/obfuscate/env.dart')).readAsStringSync();
    test('is Encrtypt lib not exists', () {
      expect(data.contains("import 'package:convert/convert.dart';"), false);
 
    });

    test('is not dev Mode', () {
       expect(data.contains("testBool1 = true;"), false);
       expect(data.contains("5987460"), false);
       expect(data.contains("dfgdgdsssssss000"), false);
    });


    test('is obfuscate', () {
      expect(data.contains("\"testBool1\""), false);
      expect(data.contains("\"testBool2\""), false);
      expect(data.contains("\"testInt1\""), false);
      expect(data.contains("\"testInt2\""), false);
      expect(data.contains("\"testStr1\""), false);
      expect(data.contains("\"testStr2\""), false);
    });


  });
  
}

