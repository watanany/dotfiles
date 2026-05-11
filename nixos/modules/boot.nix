# ──────────────────────────────────────────────────────────────
# ブートローダとカーネル設定
# UEFI を前提に systemd-boot を採用。BIOS マシンの場合は GRUB に切替が必要。
# ──────────────────────────────────────────────────────────────
{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # 残しておく世代数 (古い世代の Boot メニュー)
      systemd-boot.configurationLimit = 20;
    };

    # 最新の安定版 Linux カーネル。固定したければ
    # `pkgs.linuxKernel.packages.linux_6_12` のように変更可。
    kernelPackages = pkgs.linuxPackages_latest;

    # /tmp を再起動時に消す (一般的に望ましい挙動)
    tmp.cleanOnBoot = true;
  };
}
