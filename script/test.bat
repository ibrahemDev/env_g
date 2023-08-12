@ECHO off
setlocal

cd ..
set projectPath=%CD%


ECHO ============================
ECHO Build test Envs
ECHO ============================

ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO [ Dev Section ] 
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
set sectionPath="%projectPath%\test\dev"
tasklist | dart run env_g build -p ./%sectionPath%/env.yaml
set /p args=<%sectionPath%\.dart-definesl
tasklist | dart run  %args% ./%sectionPath%/test.dart
tasklist | del "%sectionPath%\env.dart"
tasklist | del "%sectionPath%\.dart-definesl"
tasklist | del "%sectionPath%\.flutter-definesl"


ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO [ Normal Section ] 
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
set sectionPath="%projectPath%\test\normal"
tasklist | dart run env_g build -p ./%sectionPath%/env.yaml
set /p args=<%sectionPath%\.dart-definesl
tasklist | dart run  %args% ./%sectionPath%/test.dart
tasklist | del "%sectionPath%\env.dart"
tasklist | del "%sectionPath%\.dart-definesl"
tasklist | del "%sectionPath%\.flutter-definesl"




ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO [ obfuscate Section ] 
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
set sectionPath="%projectPath%\test\obfuscate"
tasklist | dart run env_g build -p ./%sectionPath%/env.yaml
set /p args=<%sectionPath%\.dart-definesl
tasklist | dart run  %args% ./%sectionPath%/test.dart
tasklist | del "%sectionPath%\env.dart"
tasklist | del "%sectionPath%\.dart-definesl"
tasklist | del "%sectionPath%\.flutter-definesl"


ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO [ Encrypt Section ] 
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
set sectionPath="%projectPath%\test\encrypt"
tasklist | dart run env_g build -p ./%sectionPath%/env.yaml
set /p args=<%sectionPath%\.dart-definesl
tasklist | dart run  %args% ./%sectionPath%/test.dart
tasklist | del "%sectionPath%\env.dart"
tasklist | del "%sectionPath%\.dart-definesl"
tasklist | del "%sectionPath%\.flutter-definesl"


ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO [ mix Section ] 
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@
set sectionPath="%projectPath%\test\mix"
tasklist | dart run env_g build -p ./%sectionPath%/env.yaml
set /p args=<%sectionPath%\.dart-definesl
tasklist | dart run  %args% ./%sectionPath%/test.dart
tasklist | del "%sectionPath%\env.dart"
tasklist | del "%sectionPath%\.dart-definesl"
tasklist | del "%sectionPath%\.flutter-definesl"





PAUSE








