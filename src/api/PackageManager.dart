import '../elements/Pkg.dart';

abstract class PackageManager {
  Future<void> install(Pkg packages);
  Future<void> printVersion();
  Future<void> enableRepo(String repo);

  @override
  String toString();
}
