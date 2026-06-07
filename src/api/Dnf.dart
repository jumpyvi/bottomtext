import '../elements/Pkg.dart';
import 'NSpawnAPI.dart';
import 'PackageManager.dart';

class Dnf extends PackageManager {
  @override
  Future<void> install(Pkg package) async {
    await NspawnAPI.executeInNspawn('/usr/bin/dnf', [
      'install',
      '--yes',
      package.name,
    ]);
  }

  @override
  Future<void> printVersion() async {
    print(await NspawnAPI.executeInNspawn('/usr/bin/dnf', ['--version']));
  }
  
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
