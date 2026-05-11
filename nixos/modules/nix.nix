# ──────────────────────────────────────────────────────────────
# Nix デーモンの設定: flakes 有効化 / 自動 GC / store 最適化
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  nix = {
    settings = {
      # flake と nix コマンド (新 CLI) を有効化
      experimental-features = [ "nix-command" "flakes" ];

      # /nix/store 内の同一ファイルをハードリンクで共有しディスクを節約
      auto-optimise-store = true;

      # wheel グループの操作を信頼 (キャッシュ等の管理を可能に)
      trusted-users = [ "root" "@wheel" ];

      # 公式バイナリキャッシュ (デフォルトでも有効だが明示)
      substituters = [ "https://cache.nixos.org/" ];
    };

    # 古い世代を週次で自動 GC (30 日より古いものを削除)
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # store 最適化を定期実行
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # 非自由ソフトウェア (例: VSCode, NVIDIA ドライバ) を許可
  nixpkgs.config.allowUnfree = true;
}
