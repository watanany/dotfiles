# ──────────────────────────────────────────────────────────────
# Home Manager エントリ (ユーザ watanany 用)
# /home/watanany 配下に展開される dotfiles・ツールの設定をここから読み込む。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./tmux.nix
    ./packages.nix
  ];

  home = {
    username = "watanany";
    homeDirectory = "/home/watanany";

    # Home Manager 自体の互換性バージョン。
    # 一度設定したら基本変更しない (system.stateVersion と同じ思想)。
    stateVersion = "25.05";
  };

  # Home Manager 自身を home-manager コマンドとして使えるようにする
  programs.home-manager.enable = true;
}
