import 'dart:io';

class Metadatamanager {


  static Future<String> _buildReleaseContent() async {
    var osReleaseFile = File('/etc/os-release');

    var lines = await osReleaseFile.readAsLines();
    String id = lines.firstWhere(
      (line) => line.startsWith('ID=') || line.startsWith('ID_LIKE='),
      orElse: () => 'ID=_any',
    );

    return id;
  }


  static void generateRelease(String sysextPath, String releaseName) async {
    await _buildReleaseContent();

    var releaseDir = Directory('$sysextPath/usr/lib/extension-release.d');
    await releaseDir.create(recursive: true);
    var releaseFile = File('${releaseDir.path}/extension-release.$releaseName');
    var releaseContents = await Metadatamanager._buildReleaseContent();
    await releaseFile.writeAsString(releaseContents);

  }


}