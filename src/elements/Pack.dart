import 'dart:io';

import '../api/ConfigManager.dart';
import 'OS.dart';
import 'Pkg.dart';

class Pack {
  final File selfPath;

  late final Set<Pkg> packages;

  Pack(this.selfPath, OS system){
    final configHelper = Configmanager(selfPath);

    packages = configHelper.getPackages(system);
  }

  void addPackage(Pkg package){
    packages.add(package);
  }

  void displayInfo() {
    print("Packages: - ${packages.join(', ')} - will be installed...");
  }

  @override
  String toString() => selfPath.path;
}