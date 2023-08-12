

import 'dart:io';
import 'package:args/args.dart';
import 'package:env_g/src/env_g.dart';


//class
Future<void> main(List<String> arguments) async {
  String? filePath;

  if (arguments.isEmpty) return;



  final ArgParser parser = ArgParser();
  final buildCommand = parser.addCommand('build');

  buildCommand.addOption(
    'path',
    abbr: 'p',
    callback: (o){
      filePath = o;
  });





  ArgResults results = parser.parse(arguments);


  if (results.command?.name == 'build') {
    
    if(filePath == null){
      throw "no path !!!";
    }

    Envg envg = Envg(
      inputPath: filePath!
    );
    await envg.start();

    exit(0);
  }




  
  
  

}