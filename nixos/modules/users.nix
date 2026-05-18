# ──────────────────────────────────────────────────────────────
# ユーザ定義
# パスワードは初回ログイン後に `passwd` で必ず設定すること。
# (initialPassword は宣言的にしておくと事故が起きやすいので使わない方針)
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  users.users.watanany = {
    isNormalUser = true;
    description = "watanany";

    # wheel: sudo 権限
    # networkmanager: NetworkManager の操作権限
    # video / audio: GPU やオーディオデバイスへのアクセス (DE を入れる時用)
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];

    shell = pkgs.fish;
  };

  # sudo 利用時にパスワードを必須にする (デフォルト動作だが明示)
  security.sudo.wheelNeedsPassword = true;
}
