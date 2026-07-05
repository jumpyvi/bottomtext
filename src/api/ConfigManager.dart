import 'dart:io';

class Configmanager {

  static final File file = File('/etc/bottomtext/store.txt');

  static void add(String value) {
    final int lastSlash = value.lastIndexOf('/');
    final int colon = value.lastIndexOf(':');

    if (lastSlash == -1 || colon == -1 || lastSlash > colon) {
      print(
          'Error: Value format invalid. Expected something like "path/to/key:tag"');
      return;
    }

    final String key = value.substring(lastSlash + 1, colon);

    if (!file.existsSync()) {
      file.createSync();
    }

    final List<String> lines = file.readAsLinesSync();

    final bool exists = lines.any((line) => line.startsWith('$key='));

    if (!exists) {
      file.writeAsStringSync('$key=$value\n', mode: FileMode.append);
      print('Added: $key=$value');
    } else {
      print('Ignored: Key "$key" already exists.');
    }
}

static void remove(String searchString) {
  if (!file.existsSync()) {
    print('Store is empty.');
    return;
  }

  final List<String> lines = file.readAsLinesSync();

  final List<String> newLines =
      lines.where((line) => !line.contains(searchString)).toList();

  if (lines.length == newLines.length) {
    print('No matches found for "$searchString".');
  } else {
    final content = newLines.isEmpty ? '' : '${newLines.join('\n')}\n';
    file.writeAsStringSync(content);
    print(
        'Removed ${lines.length - newLines.length} entry/entries matching "$searchString".');
  }
}

static List<String> getValues() {
    if (!file.existsSync()) return [];

    return file
        .readAsLinesSync()
        .map((line) {
          final parts = line.split('=');
          return parts.length > 1 ? parts[1] : '';
        })
        .where((val) => val.isNotEmpty)
        .toList();
  }

  static Map<String, String> getPackages() {
    final File file = File('store.txt');
    if (!file.existsSync()) return {};

    final Map<String, String> packages = {};
    for (var line in file.readAsLinesSync()) {
      final parts = line.split('=');
      if (parts.length > 1) {
        packages[parts[0]] = parts.sublist(1).join('=');
      }
    }
    return packages;
  }

}