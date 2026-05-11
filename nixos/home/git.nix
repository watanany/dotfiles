# ──────────────────────────────────────────────────────────────
# Git 設定
# 個人情報 (userName / userEmail) は実際に使う値に変更してください。
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  programs.git = {
    enable = true;

    # TODO: 自分のものに書き換える
    userName = "watanany";
    userEmail = "you@example.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
    };

    # 大きめのコミットでも快適に閲覧できる差分ビューア
    delta.enable = true;

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
      ".envrc"
    ];
  };
}
