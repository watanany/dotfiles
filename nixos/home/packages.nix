# ──────────────────────────────────────────────────────────────
# ユーザ専用パッケージ
# システム共通のものは modules/packages.nix に書く。
# ここで足したものは ~/.nix-profile 経由で PATH に入る。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # モダン CLI
    ripgrep
    fd
    bat
    eza
    fzf
    zoxide
    jq
    yq-go
    du-dust   # 視覚的な du
    bottom    # 高機能 top
    tealdeer  # tldr クライアント

    # 開発ツール
    gh        # GitHub CLI
    lazygit
    delta

    # ファイル操作
    unzip
    rsync
  ];

  # XDG ディレクトリを使う
  xdg.enable = true;
}
