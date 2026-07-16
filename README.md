# claude-toolkit

個人用に作成した [Claude Code](https://claude.com/claude-code) のツールキット。
スキル・statusline など、Claude Code をカスタマイズする設定一式をまとめている。

特定プロジェクト向けの慣習（ブランチ運用・PR 規約など）を前提にした記述を含むため、
利用する際は自分の環境に合わせて調整すること。

## 構成

```
claude-toolkit/
├── skills/       # Claude Code スキル集
└── statusline/   # カスタム statusline（レートリミット表示付き）
```

## skills/

開発フロー（GitHub Issue 起点の実装、PR レビュー / 説明生成、日次レポート、
プロンプト改善）を補助する自作スキル。

| スキル | 概要 |
| --- | --- |
| `imp` | GitHub Issue を起点に、仕様の深掘り → Issue 整理 → 実装計画 → TDD 実装を進める。 |
| `pr-review` | プルリクエストを多角的な観点でレビューする。 |
| `pr-description` | PR の実装内容を分析し、フロントエンド開発者向けの使い方ガイドを含む説明文を生成・更新する。 |
| `daily-report` | マージ済み PR・オープン PR・メンバー別の着手推奨を一気通貫で表示する日次レポート。 |
| `empirical-prompt-tuning` | agent 向けテキスト指示を、バイアスを排した実行者に動かしてもらい両面で評価して反復改善する手法。 |

各スキルの詳細は `skills/<skill>/SKILL.md` を参照。

### インストール

Claude Code はグローバルスキルを `~/.claude/skills/` から読み込む。
使いたいスキルのディレクトリをそこに置く（シンボリックリンク推奨）。

```bash
git clone https://github.com/EnjoyKojima/claude-toolkit.git
cd claude-toolkit

# 例: imp と pr-review だけ使う
ln -s "$PWD/skills/imp"       ~/.claude/skills/imp
ln -s "$PWD/skills/pr-review" ~/.claude/skills/pr-review
```

シンボリックリンクにしておくと、リポを `git pull` するだけで最新版が反映される。

## statusline/

Claude Code のカスタム statusline。3行構成で以下を表示する。

```
🤖 Fable 5 │ 📊 42% │ ✏️  +120/-30 │ 🔀 feature/foo
⏱ 5h  ▰▰▰▱▱▱▱▱▱▱  32%  Resets 3pm (Asia/Tokyo)
📅 7d  ▰▰▰▰▰▱▱▱▱▱  51%  Resets Jul 20 at 9am (Asia/Tokyo)
```

- **1行目**: モデル名 / コンテキスト使用率 / 追加・削除行数 / gitブランチ
- **2〜3行目**: 5時間・7日間のレートリミット使用率（プログレスバー + リセット時刻）

レートリミットは Haiku への極小リクエスト（`max_tokens: 1`、1トークン）の
レスポンスヘッダーから取得し、360秒キャッシュする。認証は各自の Claude Code
ログイン情報（macOS Keychain / `~/.claude/.credentials.json`）を使う。

### インストール

依存: `jq`（macOS: `brew install jq`）

```bash
curl -fsSL https://raw.githubusercontent.com/EnjoyKojima/claude-toolkit/master/statusline/install.sh | bash
```

またはクローン済みなら:

```bash
bash statusline/install.sh
```

`~/.claude/statusline-command.sh` にスクリプトをコピーし、
`~/.claude/settings.json` に `statusLine` 設定をマージする（他の設定は保持）。
Claude Code を再起動すると反映される。

### カスタマイズ

環境変数で挙動を変えられる（`settings.json` の `command` に前置きして指定）。

| 環境変数 | 効果 |
| --- | --- |
| `STATUSLINE_TZ` | リセット時刻のタイムゾーン（デフォルト: `Asia/Tokyo`） |
| `RUNCAT_CLAUDE_OUT_FILE` | 設定すると [RunCat Neo](https://runcat.app/) 用のカスタムメトリクス JSON をそのパスに書き出す |

例:

```json
{
  "statusLine": {
    "type": "command",
    "command": "RUNCAT_CLAUDE_OUT_FILE=$HOME/.claude/runcat-usage.json bash ~/.claude/statusline-command.sh"
  }
}
```
