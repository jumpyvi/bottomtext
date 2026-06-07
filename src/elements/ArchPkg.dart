import 'OS.dart';
import 'Pkg.dart';

class Archpkg extends Pkg {

  final Set<OS> supportedOS = {OS.archlinux};

  Archpkg(String name) : super(name);


  @override
  String toString() {
    return "pacman";
  }

}