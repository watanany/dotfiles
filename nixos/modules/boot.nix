# ──────────────────────────────────────────────────────────────
# ブート + 低レイヤなハードウェア管理
# ・systemd-boot (UEFI) / カーネル / /tmp
# ・SSD TRIM (fstrim) / ファームウェア更新 (fwupd)
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
      # EFI ファームウェアがサポートする最大解像度で Boot メニューを表示
      systemd-boot.consoleMode = "max";
    };

    # 最新の安定版 Linux カーネル。固定したければ
    # `pkgs.linuxKernel.packages.linux_6_12` のように変更可。
    kernelPackages = pkgs.linuxPackages_latest;

    # /tmp を再起動時に消す (一般的に望ましい挙動)
    tmp.cleanOnBoot = true;
  };

  # SSD の TRIM を週次実行 (HDD では何もしないので有効化のみ)
  services.fstrim.enable = true;

  # LVFS 経由でファームウェア更新を可能にする
  # 利用: `fwupdmgr refresh && fwupdmgr get-updates && fwupdmgr update`
  services.fwupd.enable = true;
}
