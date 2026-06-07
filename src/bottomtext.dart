import 'dart:io';

import 'package:args/args.dart';
import 'package:colored_logger/colored_logger.dart';
import 'api/MetadataManager.dart';
import 'api/NSpawnAPI.dart';
import 'api/PackageManager.dart';
import 'api/Pacman.dart';
import 'api/SysextManager.dart';
import 'elements/OS.dart';
import 'elements/Pack.dart';
import 'api/ConfigManager.dart';


  Set<Pack> enabledPacks = {};

  void _loadEnabledConfigs(OS currentOS) {
      for (final yamlFile in Configmanager.getEnabledConfigs()) {
        var newPack = Pack(yamlFile, currentOS);
        enabledPacks.add(newPack);
        ColoredLogger.success('Pack $newPack loaded');
      }
  }

  void _printHelp(){
    ColoredLogger.info('Run `sudo bottomtext daemon` to start installing from config files \n ');
  }

  void _run() async{
    ColoredLogger.info("Creating temp directories...");
    
    await NspawnAPI.createWorkDirs("bottomtext");

    PackageManager pm = Pacman();

    try {
      for (final pack in enabledPacks) {
          for(final package in pack.packages){
            await pm.install(package);
          } 
      }

      ColoredLogger.info('Starting sysext generation');
      ColoredLogger.info('Extracting /usr from nspawn...');
      await SysextManager.createFromUpper(NspawnAPI.upperDir, 'bottomtext');

      ColoredLogger.info('Refreshing sysext');
      await SysextManager.refresh();
      ColoredLogger.success('Packages merged successfully');
    } catch (e) {
      print('Error: $e');
    } finally {
      await NspawnAPI.cleanup();
    }
  }

  void daemon() async{

    String id = await Metadatamanager.id();
    OS currentOS;

    switch(id){
      case "arch":
        currentOS = OS.archlinux;
      case "fedora":
        currentOS = OS.fedora;
      default:
        throw UnsupportedError("Your OS is not supported");
    }

    ColoredLogger.success("Detected OS is: " + currentOS.name);
    _loadEnabledConfigs(currentOS);
    _run();

  }


  void main(List<String> args) {

    var parser = ArgParser();
    parser.addFlag('help', abbr: 'h', negatable: false);

    var results = parser.parse(args);
    if (results['help']) {
      _printHelp();
      exit(0);
    }

    
    daemon();
  }
