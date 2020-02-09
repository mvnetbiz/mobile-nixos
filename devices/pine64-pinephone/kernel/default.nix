{
  mobile-nixos
, fetchFromGitLab
, fetchpatch
, kernelPatches ? [] # FIXME
}:

(mobile-nixos.kernel-builder {
  version = "5.5.y";
  configfile = ./config.aarch64;
  src = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    rev = "7919bfee71110bba9b053cd66843f2792d857bab";
    sha256 = "0s92s6n6308311f68ivsjlfkxmzvqk5ph9r79fcnv241n2xp5g14";
  };
  patches = [
    (fetchpatch {
      url = "https://gitlab.com/postmarketOS/pmaports/raw/master/main/linux-postmarketos-allwinner/touch-dts.patch";
      sha256 = "1vbmyvlmfxxgvsf6si28r7pvh1xclsx19n7616xz03c9c5bz2p4f";
    })
  ];
}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "install" "dtbs" ];
  postInstall = postInstall + ''
    cp -v "$buildRoot/arch/arm64/boot/dts/allwinner/sun50i-a64-dontbeevil.dtb" "$out/"
  '';
})
