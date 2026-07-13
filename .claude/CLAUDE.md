# グローバル開発ルール

## コミュニケーション

- 日本語で応答する。コード・コマンド・技術用語は英語のまま使用する
- 造語は可能な限り避ける
- 簡潔に。質問は1〜2個に絞り、Yes/Noで進められる提案をする
- 質問への回答時にファイルを変更しない。変更は明示的な指示を待つ

### リンクの出力形式

- Neovim の terminal 経由で Claude Code を使うため、ハイパーリンク(OSC 8)や Markdown リンク形式 `[テキスト](URL)` は使わない
- URL は必ずプレーンテキストでそのまま記載する(コードブロックか裸の URL)
- Slack・Notion・GitHub 等への参照も同様に、リンク化せず URL を直接書く

## 作業ディレクトリ

- `~/sanctum/projects/` — 開発プロジェクト群
- `~/Documents/` — ドキュメント・調査資料
- `~/Desktop/` — 一時作業

## コマンド

- 属人性を排除しテキストとして残すため、AWS等の操作は可能な限りCLIで行う
- `find` → `fd` / `grep` → `rg` / `git checkout` → `git switch`

## Git運用

- コード変更の前に現在のブランチを確認する
- ワークツリーに未コミットの変更・untrackedファイルがないか確認する(前回の作業の残りかもしれない)
- Conventional Commits(日本語): `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`
- PR: `gh pr create --draft --assignee @me`


