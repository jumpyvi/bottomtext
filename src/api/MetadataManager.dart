import 'dart:io';

class Metadatamanager {
  static var osReleaseFile = File('/etc/os-release');


  static Future<String?> _getLine(List<String> lines, String content) async{
     return lines.where((String line) => line.startsWith(content)).firstOrNull;
  }

  static Future<String> id() async {
    final List<String> lines = await osReleaseFile.readAsLines();

    final String? idLikeLine = await _getLine(lines, 'ID_LIKE=');
    if (idLikeLine != null) {
      return idLikeLine
          .substring('ID_LIKE='.length)
          .replaceAll('"', '')
          .replaceAll("'", "")
          .trim();
    }

    final String? idLine = await _getLine(lines, 'ID=');
    if (idLine != null) {
      return idLine
          .substring('ID='.length)
          .replaceAll('"', '')
          .replaceAll("'", "")
          .trim();
    }

    return '_any';
  }


  static void generateRelease(String sysextPath, String releaseName) async {
    var releaseDir = Directory('$sysextPath/usr/lib/extension-release.d');
    await releaseDir.create(recursive: true);
    var releaseFile = File('${releaseDir.path}/extension-release.$releaseName');
    var releaseContents = "ID=" + await id();
    await releaseFile.writeAsString(releaseContents);

  }


}