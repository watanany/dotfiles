{
  description = "NixOS + flake スターター設定 (初心者向け・拡張しやすい構成)";

  # ─────────────────────────────────────────────────────────────
  # inputs: 外部 flake (パッケージ集や Home Manager など) の参照先
  # ─────────────────────────────────────────────────────────────
  inputs = {
    # nixpkgs 本体。安定版を使いたければ "nixos-25.05" などに変更。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 旧バージョンを併用したい場合に備えた予備チャンネル (任意で利用)
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # ユーザ環境 (dotfiles・ユーザパッケージ) を宣言的に管理する Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 機種固有の最適化プロファイル集 (ThinkPad, Framework, Mac 等)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # ─────────────────────────────────────────────────────────────
  # outputs: flake が公開する成果物 (NixOS 構成など)
  # ─────────────────────────────────────────────────────────────
  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , ...
    }@inputs:
    let
      # 対象アーキテクチャ。Apple Silicon 等は "aarch64-linux"。
      system = "x86_64-linux";

      # モジュールから inputs / unstable パッケージにアクセスできるように
      # specialArgs で渡すための補助変数。
      specialArgs = { inherit inputs system; };
    in
    {
      # `nixos-rebuild switch --flake .#nixos` で適用される構成。
      # ホスト名ごとに増やしていけるよう、エントリ単位で分けておくと拡張が楽。
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            # ホスト固有設定 (ハードウェア構成・ホスト名など)
            ./hosts/nixos

            # 共通システムモジュール (機能ごとに分割)
            ./modules/nix.nix
            ./modules/boot.nix
            ./modules/networking.nix
            ./modules/locale.nix
            ./modules/packages.nix
            ./modules/users.nix

            # Home Manager を NixOS と統合
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
                users.watanany = import ./home;
              };
            }
          ];
        };
      };
    };
}
