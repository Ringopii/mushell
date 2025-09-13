{
  description = "kurukuru quickshell config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    quickshell,
  }: let
    lib = nixpkgs.lib;
    perSystem = package: (lib.listToAttrs (lib.map (a: {
      name = a;
      value = package {
        pkgs = nixpkgs.legacyPackages.${a};
        system = a;
      };
    }) (lib.attrNames nixpkgs.legacyPackages)));
    makeQmlPath = pkgs: lib.makeSearchPath "lib/qt-6/qml" (map (path: "${path}") pkgs);
    qmlPath = pkgs:
      makeQmlPath [
        quickshell.packages.${pkgs.system}.default
        pkgs.libsForQt5.qt5.qtgraphicaleffects
        pkgs.kdePackages.full
      ];
  in {
    packages = perSystem ({
      pkgs,
      system,
    }: rec {
      neofuturism-shell = let
        dependencies = [pkgs.cava quickshell.packages.${system}.default];
      in
        pkgs.writeShellScriptBin "neoshell" ''
          export PATH="${lib.makeBinPath dependencies}:$PATH"
          export QML2_IMPORT_PATH="${qmlPath pkgs}"
          ${quickshell.packages.${system}.default}/bin/quickshell $@
        '';
      default = neofuturism-shell;
    });
    devShells = perSystem ({
      pkgs,
      system,
    }: {
      default = pkgs.mkShell {
        packages = [
          self.packages.${system}.default
          pkgs.kdePackages.qtdeclarative
        ];

        QML2_IMPORT_PATH = qmlPath pkgs;

        shellHook = ''
          export QS_CONFIG_PATH="$(pwd)/src"
        '';
      };
    });
  };
}
