{
  packages,
}:
final: _prev: {
  taskledger = packages.${final.stdenv.hostPlatform.system}.taskledger or null;
  toktrail = packages.${final.stdenv.hostPlatform.system}.toktrail or null;
  archledger = packages.${final.stdenv.hostPlatform.system}.archledger or null;
  wikimason = packages.${final.stdenv.hostPlatform.system}.wikimason or null;
  codecrate = packages.${final.stdenv.hostPlatform.system}.codecrate or null;
}
