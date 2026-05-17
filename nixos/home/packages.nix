# ──────────────────────────────────────────────────────────────
# ユーザ専用パッケージ
# システム共通のものは modules/packages.nix に書く。
# ここで足したものは ~/.nix-profile 経由で PATH に入る。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # モダン CLI
    # ripgrep / fd はシステム側 (modules/packages.nix) に置いている
    bat
    eza
    fzf
    zoxide
    jq
    yq-go
    dust      # 視覚的な du
    bottom    # 高機能 top
    tealdeer  # tldr クライアント

    # 開発ツール
    gh        # GitHub CLI
    lazygit
    # delta は home/git.nix の programs.delta.enable で自動インストールされる

    # ファイル操作
    # unzip はシステム側 (modules/packages.nix) に置いている
    rsync
  ];

  # XDG ディレクトリを使う
  xdg.enable = true;
}
