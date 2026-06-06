import 'dart:io';

class HostAPI {


  static Future<void> unmount(String what) async{
      await HostAPI.execute_host('umount', ['-q', what]);
  }

  static Future<void> cp(Directory from, Directory to) async{
    await execute_host('cp', ['-a', from.path, to.path]);
  }

  static Future<String> execute_host(String executable, [List<String> args = const [],]) async {
    try {
      var result = await Process.run(executable, args);

      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      } else {
        throw Exception(
          'Command failed with exit code ${result.exitCode}: ${result.stderr}',
        );
      }
    } on ProcessException catch (e) {
      throw Exception('Failed to execute command: ${e.message}');
    }
  }
}
