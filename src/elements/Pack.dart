import 'dart:io';

import '../api/ConfigManager.dart';
import 'Pkg.dart';

class Pack {
  var packages = <Pkg>{};
  File selfPath;

  Pack(this.selfPath){
    packages = Config.getArchPackages(selfPath);
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