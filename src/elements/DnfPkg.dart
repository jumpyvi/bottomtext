import 'OS.dart';
import 'Pkg.dart';

class Dnfpkg extends Pkg {

  final Set<OS> supportedOS = {OS.almalinux, OS.fedora};

  Dnfpkg(String name) : super(name);


  @override
  String toString() {
    return "dnf";
  }

}