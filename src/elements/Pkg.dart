import 'OS.dart';

abstract class Pkg {

  final String name;
  abstract final Set<OS> supportedOS;

  Pkg(this.name);

  @override
  String toString() => name;
  
}
