import 'HostAPI.dart';

class Oras {
  static Future<String> execute(List<String> args) async {
    return await HostAPI.execute_host('/home/linuxbrew/.linuxbrew/bin/oras', args);
  }

  static Future<String> pull(String imageReference, {String? outputDir}) async {
    final args = ['pull', imageReference];
    if (outputDir != null) {
      args.addAll(['-o', outputDir]);
    }
    return await execute(args);
  }
}
