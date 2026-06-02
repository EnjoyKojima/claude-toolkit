# claude-skills

個人用に作成した [Claude Code](https://claude.com/claude-code) のスキル集。

開発フロー（GitHub Issue 起点の実装、PR レビュー / 説明生成、日次レポート、
プロンプト改善）を補助する自作スキルをまとめている。特定プロジェクト向けの
慣習（ブランチ運用・PR 規約など）を前提にした記述を含むため、利用する際は
自分の環境に合わせて調整すること。

## 収録スキル

| スキル | 概要 |
| --- | --- |
| `imp` | GitHub Issue を起点に、仕様の深掘り → Issue 整理 → 実装計画 → TDD 実装を進める。 |
| `pr-review` | プルリクエストを多角的な観点でレビューする。 |
| `pr-description` | PR の実装内容を分析し、フロントエンド開発者向けの使い方ガイドを含む説明文を生成・更新する。 |
| `daily-report` | マージ済み PR・オープン PR・メンバー別の着手推奨を一気通貫で表示する日次レポート。 |
| `empirical-prompt-tuning` | agent 向けテキスト指示を、バイアスを排した実行者に動かしてもらい両面で評価して反復改善する手法。 |

各スキルの詳細は `<skill>/SKILL.md` を参照。

## インストール

Claude Code はグローバルスキルを `~/.claude/skills/` から読み込む。
使いたいスキルのディレクトリをそこに置く（シンボリックリンク推奨）。

```bash
git clone https://github.com/EnjoyKojima/claude-skills.git
cd claude-skills

# 例: imp と pr-review だけ使う
ln -s "$PWD/imp"       ~/.claude/skills/imp
ln -s "$PWD/pr-review" ~/.claude/skills/pr-review
```

シンボリックリンクにしておくと、リポを `git pull` するだけで最新版が反映される。
