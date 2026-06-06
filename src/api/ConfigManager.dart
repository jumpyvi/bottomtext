import 'package:colored_logger/colored_logger.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';
import '../elements/ArchPkg.dart';


class Config {

  static Set<Archpkg> getArchPackages(File config) {
    final yamlMap = loadYaml(config.readAsStringSync());
    if (yamlMap == null) return {};

    final packages = yamlMap['arch-packages'];
    if (packages is List) {
      return packages.map((package) => Archpkg(package as String)).toSet();
    }
    return {};
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
    ColoredLogger.error('Error reading from /etc/bottomtext.d, does it exists?');
    exit(0);
  }
  }

}
