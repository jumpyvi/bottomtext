import 'OS.dart';
import 'Pkg.dart';

class Aurpkg extends Pkg {

  final Set<OS> supportedOS = {OS.archlinux};

  Aurpkg(String name) : super(name);

  @override
  String toString() {
    return "aur";
  }
}
