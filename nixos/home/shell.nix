# ──────────────────────────────────────────────────────────────
# シェル環境: fish + starship + direnv
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    # 起動時に呼ばれる初期化スクリプト
    interactiveShellInit = ''
      set -gx EDITOR nvim

      # greeting (起動メッセージ) を消す
      set -U fish_greeting ""
    '';

    shellAliases = {
      ll = "eza -l --git";
      la = "eza -la --git";
      lt = "eza --tree --level=2";
      g = "git";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    shellAbbrs = {
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gco = "git checkout";
      gp = "git pull";
    };
  };

  # プロンプト
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    # Nerd Font を使う前提でアイコンを有効化
    settings = {
      add_newline = true;
    };
  };

  # `.envrc` で自動的に環境変数・Nix shell を読み込む
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  # 統合系ツール
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
  };

  programs.bat.enable = true;
}
