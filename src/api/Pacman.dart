import '../elements/Pkg.dart';
import 'NSpawnAPI.dart';
import 'PackageManager.dart';

class Pacman extends PackageManager {

  @override
  Future<void> install(Set<Pkg> packages) async {
    await NspawnAPI.executeInNspawn('/usr/bin/pacman', [
      '-Sy',
      '--noconfirm',
      '--ask=4',
      '--needed',
      ...packages.map((pkg) => pkg.name),
    ]);
  }

  @override
  Future<void> printVersion() async {
    print(await NspawnAPI.executeInNspawn('/usr/bin/pacman', ['--version']));
  }
}
