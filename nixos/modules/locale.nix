# ──────────────────────────────────────────────────────────────
# ロケール・タイムゾーン・キーボード・日本語入力
# IME (fcitx5-mozc) はデスクトップ環境を導入した時点で初めて意味を持つ。
# CLI のみの間は何もしない。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "ja_JP.UTF-8";

    # 文字種別ごとに英語 (POSIX) を使いたい場合は extraLocaleSettings で個別指定可
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8"; # システムメッセージは英語のほうが検索しやすい
    };

    # 日本語入力 (DE を入れたら自動で使えるようになる)
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  # コンソール (TTY) のキーマップ
  console.keyMap = "us";

  # X / Wayland のキーマップ (DE を入れた時に有効)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
