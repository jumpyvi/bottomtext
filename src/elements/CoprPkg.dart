import 'OS.dart';
import 'Pkg.dart';

class Coprpkg extends Pkg {
  final Set<OS> supportedOS = {OS.almalinux, OS.fedora};

  Coprpkg(String name) : super(name);
}
