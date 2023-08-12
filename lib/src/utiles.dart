import 'package:convert/convert.dart';
import 'dart:math' as math;

class Utiles {
  /// set any key inside it and befor create any random check if exists for unque id
  static final List<String> _listOfRandoms = [];

  static final math.Random _rnd = math.Random();

  static String base64ToHex(String val) {
    return hex.encode(val.codeUnits);
  }

  static String hexToBase64(String val) {
    return String.fromCharCodes(hex.decode(val));
  }

  static String getRandomString(int length, {String chars = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890'}) {
    String randomId = String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));
    if (_listOfRandoms.contains(randomId.toLowerCase()) || '1234567890'.contains(randomId.split('')[0])) {
      return getRandomString(length);
    }
    _listOfRandoms.add(randomId.toLowerCase());

    return randomId;
  }

  static String getRandomKey() {
    return getRandomString(15);
  }

  static String getRandomPass() {
    return getRandomString(32, chars: 'qwertyuiopasdfghjklzxcvbnm{}<>?/:;~!@#%^&*(_+)1234567890');
  }
}
