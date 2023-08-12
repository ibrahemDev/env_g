

import 'dart:io';

import 'package:test/test.dart';
import 'env.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {


  group('Test args', () {
    test('test Str', () {
      expect(EnvEncrypt().testStr1, "dfgdgdsssssss000");
      expect(EnvEncrypt().testStr2, "asdasdzzzzzzzqef");
    });
    test('test bool', () {
      expect(EnvEncrypt().testBool1, true);
      expect(EnvEncrypt().testBool2, false);
    });
    test('test int', () {
      

      expect(EnvEncrypt().testInt1, 5987460);
      expect(EnvEncrypt().testInt2, 651651);

      
    });
  });



  group('Test Genrated File', () {
    String data =  File(path.normalize('./test/encrypt/env.dart')).readAsStringSync();
    test('is Encrtypt lib exists', () {
      expect(data.contains("import 'package:convert/convert.dart';"), true);
 
    });

    test('is not dev Mode', () {
       expect(data.contains("testBool1 = true;"), false);
       expect(data.contains("5987460"), false);
       expect(data.contains("dfgdgdsssssss000"), false);
    });


    test('is not obfuscate', () {
      expect(data.contains("\"testBool1\""), true);
      expect(data.contains("\"testBool2\""), true);
      expect(data.contains("\"testInt1\""), true);
      expect(data.contains("\"testInt2\""), true);
      expect(data.contains("\"testStr1\""), true);
      expect(data.contains("\"testStr2\""), true);
    });


  });
  
}

