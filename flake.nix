{
  description = "QMK firmware development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.qmk
            pkgs.gcc-arm-embedded
          ];

          # Point the qmk CLI at this checkout instead of ~/qmk_firmware.
          shellHook = ''
            export QMK_HOME="$PWD"
          '';
        };
      });
    };
}
