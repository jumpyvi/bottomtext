import 'dart:io';
import 'package:colored_logger/colored_logger.dart';
import 'package:yaml/yaml.dart';

import '../elements/ArchPkg.dart';
import '../elements/AurPkg.dart';
import '../elements/CoprPkg.dart';
import '../elements/DnfPkg.dart';
import '../elements/OS.dart';
import '../elements/Pkg.dart';

class Configmanager {
  final File config;

  Configmanager(this.config);

  Set<Pkg> _getPackages<T extends Pkg>(
      String yamlKey, T Function(String) builder) {
    final yamlMap = loadYaml(config.readAsStringSync());
    if (yamlMap == null) return {};

    final packages = yamlMap[yamlKey];
    if (packages is List) {
      return packages.map((package) => builder(package as String)).toSet();
    }

    return {};
  }

  Set<Pkg> getPackages(OS system) {
    switch (system.name.toLowerCase()) {
      case 'archlinux':
        return {
          ..._getPackages<Archpkg>('arch-packages', (name) => Archpkg(name)),
          ..._getPackages<Aurpkg>('aur-packages', (name) => Aurpkg(name)),
        };
      case 'fedora':
        return {
          ..._getPackages<Dnfpkg>('dnf-packages', (name) => Dnfpkg(name)),
          ..._getPackages<Coprpkg>('copr-packages', (name) => Coprpkg(name)),
        };
      default:
        throw ArgumentError('Mysterious OS: ${system.name}');
    }
  }

  static Set<File> getEnabledConfigs() {
    final dir = Directory('/etc/bottomtext.d');
    try {
      return dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.yaml'))
          .toSet();
    } catch (e) {
      ColoredLogger.error(
          'Error reading from /etc/bottomtext.d, does it exists?');
      exit(0);
    }
  }
}
