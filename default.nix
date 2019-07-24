self: super:

let mkDart = { channel, release, sha256 }: (
  let platform = if self.stdenv.isDarwin then "macos" else "linux"; in
  let architecture = "x64"; in

  self.stdenv.mkDerivation {
    name = "dart-${release}";
    src = builtins.fetchurl {
      inherit sha256;
      url = builtins.concatStringsSep "/" [
        "https://storage.googleapis.com"
        "dart-archive"
        "channels"
        channel
        "release"
        release
        "sdk"
        "dartsdk-${platform}-${architecture}-release.zip"
      ];
    };
    buildInputs = with self.pkgs; [
      unzip
    ];
    unpackCmd = ''
      unzip $curSrc
    '';
    installPhase = ''
      mkdir $out
      cp -r . $out
    '';
  }
); in

let dart_2-1-0 = mkDart {
  channel = "stable";
  release = "2.1.0";
  sha256 =
    if self.stdenv.isDarwin
    then "0sm7b835f8gzcq30qlf1aslckhpy424cv9l5rgcg60sy5lxh2xjm"
    else "1dnwi85cxmfx2c0ks200v6dic3wgzgsv6wy2svgdn1n5zcl30rr4";
}; in

let dart_2-1-0_dev-9-4 = mkDart {
  channel = "dev";
  release = "2.1.0-dev.9.4";
  sha256 =
    if self.stdenv.isDarwin
    then "0mhdz2zahb9yy717lwsv6jzia8xb76n6vbxq970d6g8pl5cw2fpd"
    else "0vrk0pkw200104zvfdm10d50jgflq4ayrr9hfpxbxsknjkmwzaw5";
}; in

{
  dart = dart_2-1-0;
  inherit mkDart;
  inherit dart_2-1-0;
  inherit dart_2-1-0_dev-9-4;
}
