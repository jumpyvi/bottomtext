import 'dart:io';

import 'HostAPI.dart';
import 'MetadataManager.dart';

class SysextManager {
  static const String SYSEXT_PATH = '/var/lib/extensions/bottomtext.raw';

  static Future<void> createFromUpper(String upperDir, String releaseName) async {
    var upperUsr = Directory('$upperDir/usr');
    if (!await upperUsr.exists()) {
      throw Exception(
        'Expected directory not found at ${upperUsr.path}',
      );
    }

    await _recreateDirectory(Directory(SYSEXT_PATH));
    var destinationUsr = Directory('$SYSEXT_PATH/usr');

    await HostAPI.cp(upperUsr, destinationUsr);


    Metadatamanager.generateRelease(SYSEXT_PATH, releaseName);
  }

  static Future<void> refresh() async {
    await HostAPI.execute_host('systemd-sysext', ['refresh']);
  }

  static Future<void> _recreateDirectory(Directory directory) async {
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create(recursive: true);
  }

}
