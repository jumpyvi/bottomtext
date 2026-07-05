import 'HostAPI.dart';

class Sysext {
  static Future<String> execute(List<String> args) async {
    return await HostAPI.execute_host('systemd-sysext', args);
  }

  static Future<String> merge() async {
    return await execute(['merge']);
  }

  static Future<String> unmerge() async {
    return await execute(['unmerge']);
  }

  static Future<String> refresh() async {
    return await execute(['refresh']);
  }

  static Future<String> status() async {
    return await execute(['status']);
  }
}
