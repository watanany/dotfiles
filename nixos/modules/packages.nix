# ──────────────────────────────────────────────────────────────
# システム全体で使う最低限のパッケージ
# ユーザ専用のものは home/packages.nix に書く。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # 基本ツール
    git
    vim
    curl
    wget
    file
    which
    tree
    unzip
    htop

    # モダン CLI
    ripgrep
    fd

    # ハードウェア情報
    pciutils
    usbutils
    lsof
  ];

  # fish を default shell にする場合、システム側で有効化が必要
  # (これがないとログインシェル経由の PATH 補完などが壊れる)
  programs.fish.enable = true;

  # /run/current-system/sw/share/zsh/site-functions 等を有効化したい時のため
  # zsh も最低限有効にしておく (使わなければ削除可)
  programs.zsh.enable = false;
}
