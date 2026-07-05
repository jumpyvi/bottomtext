import 'dart:io';

import 'package:args/args.dart';
import 'package:colored_logger/colored_logger.dart';

import 'api/ConfigManager.dart';
import 'api/Oras.dart';
import 'api/Sysext.dart';


  void _printHelp(){
    ColoredLogger.info('Run `bottomtext add SOURCE` to start installing from OCI repos \n ');
  }

  void sync() async{
    ColoredLogger.info("Starting sync...");
      try {
        final extDir = Directory('/var/lib/extensions');

        if (!extDir.existsSync()) {
          extDir.createSync(recursive: true);
        }

        ColoredLogger.info("Removing bottomtext managed extensions...");
        for (var entity in extDir.listSync()) {
          if (entity is Directory && entity.path.endsWith('_bt')) {
            entity.deleteSync(recursive: true);
            ColoredLogger.info("Removed ${entity.path}");
          }
        }

        Map<String, String> packages = Configmanager.getPackages();

        if (packages.isEmpty) {
          ColoredLogger.warning("No packages found in configuration.");
          exit(1);
        }

        for (var entry in packages.entries) {
          final pkgName = entry.key;
          final pkgUrl = entry.value;

          final outDir = '${extDir.path}/${pkgName}_bt';

          Directory(outDir).createSync(recursive: true);

          ColoredLogger.info("Pulling $pkgName into $outDir...");
          await Oras.pull(pkgUrl, outputDir: outDir);
        }

        ColoredLogger.info("Refreshing system extensions...");
        await Sysext.refresh();
        ColoredLogger.info("Sync complete!");

      } catch (e) {
        ColoredLogger.info("Sync failed: $e");
        exit(1);
      }
  }


  void main(List<String> args) {

    var parser = ArgParser();
    parser.addFlag('help', abbr: 'h', negatable: false);

    parser.addCommand('sync');
    parser.addCommand('add');
    parser.addCommand('del');

    var results = parser.parse(args);

    if (results['help']) {
      _printHelp();
      exit(0);
    }

    var commandArgs = results.command!.rest;

    switch (results.command?.name) {
      case 'sync':
        ColoredLogger.info("sync");
        sync();
        break;
      case 'add':
        if (commandArgs.isEmpty) {
        ColoredLogger.warning("Please provide a package to add.");
        exit(1);
        }
        Configmanager.add(commandArgs.first);
        break;
      case 'del':
        if (commandArgs.isEmpty) {
          ColoredLogger.warning("Please provide a package to remove.");
          exit(1);
        }
        Configmanager.remove(commandArgs.first);
        break;
      default:
        ColoredLogger.warning("No subcommands found");
    }

    if (results.command == null) {
      _printHelp();
      exit(1);
    }

  }
