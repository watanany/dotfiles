# NixOS + Flake スターター設定

NixOS 初心者でも扱えて、機能ごとに足し引きしやすい flake ベースの最小構成。
fish + Home Manager 同梱、日本語ロケール初期化済み、CLI ツール (ripgrep / fd / bat / eza / fzf / zoxide / gh / lazygit ...) 入り。

> 開発ブランチ: `claude/nixos-flake-starter-config-9xpcA`

---

## 全体像

```
flake.nix                      ← 玄関。inputs(外部リポ) と outputs(構成) を宣言
 │
 ├── hosts/nico/              ← このマシン固有 (hostname, hardware)
 │     ├── default.nix
 │     └── hardware-configuration.nix  ← nixos-generate-config で生成して差し替え
 │
 ├── modules/                  ← システム全体に効く「部品」
 │     ├── nix.nix             ← flakes / GC / 最適化
 │     ├── boot.nix            ← systemd-boot + EFI + 最新カーネル
 │     ├── networking.nix      ← NetworkManager + firewall + OpenSSH (root拒否)
 │     ├── locale.nix          ← ja_JP / Asia/Tokyo / US 配列 / fcitx5-mozc
 │     ├── packages.nix        ← システム共通の最低限ツール
 │     └── users.nix           ← watanany ユーザ (fish, wheel)
 │
 └── home/                     ← Home Manager (ユーザ環境)
       ├── default.nix         ← ここから各ファイルを imports
       ├── shell.nix           ← fish + starship + direnv + fzf + zoxide + eza
       ├── git.nix             ← programs.git (delta 同梱)
       ├── neovim.nix          ← programs.neovim
       ├── tmux.nix            ← programs.tmux
       └── packages.nix        ← ユーザ専用 CLI ツール
```

読む順序のおすすめ: `flake.nix` → `hosts/nico/default.nix` → `modules/*.nix` → `home/default.nix`

---

## デフォルトで ON のもの

- [x] flakes + 新 nix コマンド (`nix-command`)
- [x] /nix/store 自動最適化 + 週次 GC (30 日)
- [x] `allowUnfree = true`
- [x] systemd-boot (UEFI) + 最新カーネル
- [x] SSD TRIM (fstrim) + ファームウェア更新 (fwupd)
- [x] NetworkManager
- [x] ファイアウォール (22/tcp のみ開放)
- [x] OpenSSH (root ログイン拒否、初期はパスワード認証許可)
- [x] ロケール: 日本語 / タイムゾーン: Asia/Tokyo / キーマップ: US 配列
- [x] fcitx5 + mozc (DE 導入時に効く)
- [x] fish + starship + direnv (nix-direnv)
- [x] ripgrep, fd, bat, eza, fzf, zoxide, jq, gh, lazygit, delta, ...
- [x] Neovim (`defaultEditor`)
- [x] tmux (mouse, prefix=C-a, vi keys)
- [x] Home Manager を NixOS と統合

---

## セットアップ手順

前提: NixOS インストーラから最低限ブート可能な状態 (`/etc/nixos/hardware-configuration.nix` が生成済み)。

```bash
# 1. リポジトリを取得
git clone https://github.com/watanany/dotfiles.git ~/dotfiles
cd ~/dotfiles/nixos

# 2. 実機のハードウェア設定を生成して置換
sudo nixos-generate-config --show-hardware-config \
  > hosts/nico/hardware-configuration.nix

# 3. (任意) ホスト名を変更
$EDITOR hosts/nico/default.nix

# 4. (任意) git の userName / userEmail を自分のものに変更
$EDITOR home/git.nix

# 5. 構成を適用
sudo nixos-rebuild switch --flake .#nico

# 6. ログインユーザのパスワードを設定
sudo passwd watanany
```

---

## 日々の運用コマンド

| 用途 | コマンド |
|---|---|
| 設定を適用 | `sudo nixos-rebuild switch --flake .#nico` |
| 適用せずビルドだけ | `nixos-rebuild build --flake .#nico` |
| flake input を更新 | `nix flake update` |
| 不要 store の即時削除 | `sudo nix-collect-garbage -d` |
| 直前世代に戻す | `sudo nixos-rebuild switch --rollback` |
| 個別パッケージ検索 | `nix search nixpkgs <name>` |

---

## 拡張ガイド

### デスクトップ環境を足す (GNOME 例)

`modules/desktop.nix` を作成:

```nix
{ ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
```

`flake.nix` の `modules` に `./modules/desktop.nix` を追加。

### オーディオ (PipeWire)

`modules/audio.nix`:

```nix
{ ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
```

### 日本語フォント

`modules/fonts.nix`:

```nix
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
}
```

### ホストをもう一台足す

```
nixos/hosts/laptop/
  ├── default.nix
  └── hardware-configuration.nix
```

`flake.nix` に追加:

```nix
nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  modules = [ ./hosts/laptop /* + 共通 modules */ ];
};
```

### 既存 dotfiles を Home Manager 経由で読ませる

`home/default.nix` の `home.file` に追記:

```nix
home.file = {
  ".tmux.conf".source = ../../.tmux.conf;
  ".config/nvim".source = ../../.config/nvim;
};
```

### Secrets 管理

[sops-nix](https://github.com/Mic92/sops-nix) もしくは [agenix](https://github.com/ryantm/agenix) を `inputs` に追加して導入する。

---

## セキュリティ補足: SSH

初期状態ではパスワード認証が有効。鍵認証に切り替えるには:

```bash
# 1. 公開鍵をホストに設置 (クライアント側で実行)
ssh-copy-id watanany@<host>

# 2. modules/networking.nix を編集
#    PasswordAuthentication = false に変更
# 3. sudo nixos-rebuild switch --flake .#nico
```

---

## トラブルシュート

- **`error: file 'hardware-configuration.nix' ... has 0 fileSystems` / boot しない**
  → 手順 2 の `nixos-generate-config` を忘れている。実機で生成して差し替え。
- **`nixos-rebuild switch --flake .#nico` で `nixosConfigurations.nico not found`**
  → `flake.nix` の attribute 名 (`nixosConfigurations.nico`) と `--flake .#<名前>` の名前を揃える。`hostName` は別物 (任意の名前で OK だが、attribute 名と揃えておくと混乱しない)。
- **ログイン後も fish にならない**
  → `chsh -s $(which fish)` ではなく、`users.users.watanany.shell = pkgs.fish;` を変更して `nixos-rebuild switch` する。

---

## 次に読むと良い公式ドキュメント

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [nixpkgs / NixOS option search](https://search.nixos.org/options)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Zero to Nix](https://zero-to-nix.com/) (初心者向けチュートリアル)
