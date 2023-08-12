#!/usr/bin/env bash


echo "============================"
echo "Build test Envs"
echo "============================"
SCRIPTPATH=$(readlink -f "$0")
SCRIPTPATHDIR=$(dirname "$SCRIPTPATH")
PROJECTPATH="${SCRIPTPATHDIR%/*}"
args=""
TESTPATH=""

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "[ Dev Section ] "
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
TESTPATH="$PROJECTPATH/test/dev"
dart run env_g build -p $TESTPATH/env.yaml
args=$(cat $TESTPATH/.dart-definesl)
dart run  $args $TESTPATH/test.dart
rm $TESTPATH/.dart-definesl
rm $TESTPATH/.flutter-definesl
rm $TESTPATH/env.dart


echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "[ Normal Section ] "
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
TESTPATH="$PROJECTPATH/test/normal"
dart run env_g build -p $TESTPATH/env.yaml
args=$(cat $TESTPATH/.dart-definesl)
dart run  $args $TESTPATH/test.dart
rm $TESTPATH/.dart-definesl
rm $TESTPATH/.flutter-definesl
rm $TESTPATH/env.dart


echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "[ obfuscate Section ] "
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
TESTPATH="$PROJECTPATH/test/obfuscate"
dart run env_g build -p $TESTPATH/env.yaml
args=$(cat $TESTPATH/.dart-definesl)
dart run  $args $TESTPATH/test.dart
rm $TESTPATH/.dart-definesl
rm $TESTPATH/.flutter-definesl
rm $TESTPATH/env.dart



echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "[ Encrypt Section ] "
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
TESTPATH="$PROJECTPATH/test/encrypt"
dart run env_g build -p $TESTPATH/env.yaml
args=$(cat $TESTPATH/.dart-definesl)
dart run  $args $TESTPATH/test.dart
rm $TESTPATH/.dart-definesl
rm $TESTPATH/.flutter-definesl
rm $TESTPATH/env.dart



echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "[ Mix Section ] "
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
TESTPATH="$PROJECTPATH/test/mix"
dart run env_g build -p $TESTPATH/env.yaml
args=$(cat $TESTPATH/.dart-definesl)
dart run  $args $TESTPATH/test.dart
rm $TESTPATH/.dart-definesl
rm $TESTPATH/.flutter-definesl
rm $TESTPATH/env.dart
