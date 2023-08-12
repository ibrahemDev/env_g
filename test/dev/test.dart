

import 'dart:io';

import 'package:test/test.dart';
import 'env.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {


  group('Test args', () {

    test('test bool', () {
      expect(EnvDev.testBool1, true) ;
      expect(EnvDev.testBool2, false);
    });

    test('test int', () {
      expect(EnvDev.testInt1, 5987460);
      expect(EnvDev.testInt2, 651651);

    });
    test('test str', () {
      expect(EnvDev.testStr1, "dfgdgdsssssss000");
      expect(EnvDev.testStr2, "asdasdzzzzzzzqef");
    });

  
  });



  group('Test Genrated File', () {
    String data =  File(path.normalize('./test/dev/env.dart')).readAsStringSync();
    test('is Encrtypt lib not exists', () {
      expect(data.contains("import 'package:convert/convert.dart';"), false);
 
    });

    test('is dev Mode', () {
      expect(data.contains("testBool1 = true;"), true);
      expect(data.contains("dfgdgdsssssss000"), true);
      expect(data.contains("testInt1 = 5987460;"), true);
    });



  });
  
}

