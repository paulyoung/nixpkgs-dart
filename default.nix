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

let dart-2_7_2 = mkDart {
  channel = "stable";
  release = "2.7.2";
  sha256 =
    if self.stdenv.isDarwin
    then "111zl075qdk2zd4d4mmfkn30jmzsri9nq3nspnmc2l245gdq34jj"
    else "0vvsgda1smqdjn35yiq9pxx8f5haxb4hqnspcsfs6sn5c36k854v";
}; in

let dart-2_8_0-20_11_beta = mkDart {
  channel = "beta";
  release = "2.8.0-20.11.beta";
  sha256 =
    if self.stdenv.isDarwin
    then "1lg131xl15agj737vvdc77zgbrpbswbds5nbbwwpdybccvhxwxfm"
    else "1zgi22gggysml0qhzm9a5bva35lv3ngx2kkddjpg5ay5x9b1nc9k";
}; in

let dart-2_9_0-3_0_dev = mkDart {
  channel = "dev";
  release = "2.9.0-3.0.dev";
  sha256 =
    if self.stdenv.isDarwin
    then "150h04x7zfr5cqv4kz8niqdymqqr0ds38c3gy9wg0lg7w7fv82ka"
    else "1zk52qbmhdbifmfdifhz64ssq3acwfrcqhnqmfkbavihm6z8h34i";
}; in

{
  dart = dart-2_7_2;
  inherit mkDart;
  inherit dart-2_7_2;
  inherit dart-2_8_0-20_11_beta;
  inherit dart-2_9_0-3_0_dev;
}
