# ──────────────────────────────────────────────────────────────
# Neovim
# 既存の ~/.config/nvim をそのまま使う前提。Nix から最低限の wrapper だけ提供。
# 設定を Home Manager で管理したくなったら programs.neovim.extraConfig や
# `home.file.".config/nvim".source = ../../.config/nvim;` 等で取り込める。
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
