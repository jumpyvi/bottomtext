import '../elements/Pkg.dart';

abstract class PackageManager {
  Future<void> install(Set<Pkg> packages);
  Future<void> printVersion();
}
