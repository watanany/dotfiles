# ──────────────────────────────────────────────────────────────
# ホスト固有設定: このマシン固有のもの (hostname, stateVersion, hardware)
# 同じ構成を別マシンに展開したい場合は hosts/<別名>/ を増やす。
# ──────────────────────────────────────────────────────────────
{ ... }:
{
  imports = [
    # nixos-generate-config で生成したファイルを置く場所
    ./hardware-configuration.nix
  ];

  # このマシンのホスト名 (好きな名前に変更可)
  networking.hostName = "nixos";

  # 最初に NixOS をインストールした時のバージョンを記録しておく値。
  # ここを安易に上げると、データを引き継ぐサービスで非互換が起きる可能性があるため
  # 通常はインストール時のまま据え置きにする。
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.05";
}
