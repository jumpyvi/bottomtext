import 'dart:io';

import 'package:args/args.dart';
import 'package:colored_logger/colored_logger.dart';
import 'api/NSpawnAPI.dart';
import 'api/PackageManager.dart';
import 'api/Pacman.dart';
import 'api/SysextManager.dart';
import 'elements/Pack.dart';
import 'api/ConfigManager.dart';


Set<Pack> enabledPacks = {};

  void _loadEnabledConfigs() {
    for (final yamlFile in Config.getEnabledConfigs()) {
      var newPack = Pack(yamlFile);
      enabledPacks.add(newPack);
      ColoredLogger.success('Pack $newPack loaded');
    }
  }

  void _printHelp(){
    ColoredLogger.info('Run `sudo bottomtext daemon` to start installing from config files \n ');
  }

  void _run() async{
    ColoredLogger.info("Creating temp directories...");
    
    await NspawnAPI.createWorkDirs("pacman");
    PackageManager pm = Pacman();

    try {
      ColoredLogger.info('Starting pacman...');
      await pm.printVersion();

      for (final pack in enabledPacks) {
        await pm.install(pack.packages);
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

    _loadEnabledConfigs();
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
