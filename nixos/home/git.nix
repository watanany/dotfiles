# ──────────────────────────────────────────────────────────────
# Git 設定
# 個人情報 (user.name / user.email) は実際に使う値に変更してください。
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  programs.git = {
    enable = true;

    # Home Manager 25.11 以降は extraConfig / userName / userEmail を
    # まとめて programs.git.settings に書く新 API。
    settings = {
      # TODO: 自分のものに書き換える
      user.name = "watanany";
      user.email = "you@example.com";

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
      ".envrc"
    ];
  };

  # 大きめのコミットでも快適に閲覧できる差分ビューア。
  # 25.11 で programs.git.delta から独立し、git integration は明示が必要。
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
