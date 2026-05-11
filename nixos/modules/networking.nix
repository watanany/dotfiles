# ──────────────────────────────────────────────────────────────
# ネットワーク・ファイアウォール・SSH
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  networking = {
    # 有線・無線とも GUI/CLI から扱える NetworkManager を有効化
    networkmanager.enable = true;

    # ファイアウォールは有効。必要なポートだけ開ける。
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
      ];
      # allowedUDPPorts = [ ];
    };
  };

  # SSH サーバ
  # 鍵認証に切り替えたら PasswordAuthentication = false にすると安全。
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
    };
  };
}
