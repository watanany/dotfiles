# ──────────────────────────────────────────────────────────────
# tmux
# 既存の ~/.tmux.conf を使いたければ programs.tmux.extraConfig や
# `home.file.".tmux.conf".source = ../../.tmux.conf;` で取り込める。
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
    historyLimit = 50000;
    escapeTime = 10;
  };
}
