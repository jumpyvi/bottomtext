import '../elements/Pkg.dart';
import 'NSpawnAPI.dart';
import 'PackageManager.dart';

class Pacman extends PackageManager {

  @override
  Future<void> install(Pkg package) async {

    await enableRepo("multilib");
    await NspawnAPI.executeInNspawn('/usr/bin/pacman', [
      '-Sy',
      '--noconfirm',
      '--ask=4',
      '--needed',
      package.name,
    ]);
  }

  @override
  Future<void> enableRepo(String repo) async {
    await NspawnAPI.executeInNspawn('/bin/bash', [
      '-c',
      'echo -e "\n[$repo]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf',
    ]);
  }

  @override
  Future<void> printVersion() async {
    print(await NspawnAPI.executeInNspawn('/usr/bin/pacman', ['--version']));
  }
}
