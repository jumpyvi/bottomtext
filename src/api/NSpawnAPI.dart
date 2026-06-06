import 'dart:io';

import 'HostAPI.dart';

class NspawnAPI {
  static late String mergedDir;
  static late String upperDir;
  static late Directory _workspace;

  static Future<void> createWorkDirs(String prefix) async {
    _workspace = await Directory.systemTemp.createTemp('bottomtext-$prefix-');
    upperDir = '${_workspace.path}/upper';
    mergedDir = '${_workspace.path}/merged';
    final workDir = '${_workspace.path}/work';

    await Future.wait([
      Directory(upperDir).create(recursive: true),
      Directory(workDir).create(recursive: true),
      Directory(mergedDir).create(recursive: true),
    ]);

    await HostAPI.execute_host('mount', [
      '-t',
      'overlay',
      'overlay',
      '-o',
      'lowerdir=/,upperdir=$upperDir,workdir=$workDir',
      mergedDir,
    ]);
  }

  static Future<String> executeInNspawn(String executable,
      [List<String> args = const []]) async {
    final result = await Process.run(
        'systemd-nspawn',
        [
          '-q',
          '-D',
          mergedDir,
          '--resolv-conf=copy-host',
          '--pipe',
          executable,
          ...args
        ],
        stdoutEncoding: systemEncoding,
        stderrEncoding: systemEncoding);

    if (result.exitCode != 0)
      throw Exception('Nspawn failed [${result.exitCode}]: ${result.stderr}');

    return result.stdout.toString().trim();
  }

  static Future<void> cleanup() async {

    await HostAPI.unmount(mergedDir);
    
    if (await _workspace.exists()) await _workspace.delete(recursive: true);
  }
}