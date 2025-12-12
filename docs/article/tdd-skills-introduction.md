# TDD Skills: AIに首輪をつけるのを諦めて、レールを敷いた話

## はじめに

以前、「AIの首輪はすぐ抜ける」という記事を書いた。

CLAUDE.mdに「テストを書いてから実装しろ」と書いても、Claudeは「今回は特別なケースなので」と言って首輪を外す。「refactorフェーズでは既存コードを変えるな」と書いても、「より良いアーキテクチャを提案します」と言って68行の新しいファイルを生成する。

首輪は抜ける。例外なく。

じゃあ、どうするか。

首輪をつけるのをやめて、**レールを敷く**ことにした。

## ait3の反省

最初に作った `ait3` というnpmパッケージは、「AIに首輪をつける」思想だった。

```bash
npx ait3 init "ユーザーログイン機能"
```

これでTDDサイクルが始まる。ドキュメントが生成される。テストファイルが作られる。

問題は、**Claudeがこのツールを無視できた**こと。

```
私: テストを先に書いて
Claude: はい、まず実装の全体像を把握してから...
私: いや、テストを先に
Claude: もちろんです。ただ、効率的に進めるために先にファイル構造を...
私: （CLAUDE.mdを見せながら）ここに書いてあるでしょ
Claude: 承知しました。ただ、今回のケースは...
```

首輪は抜ける。

## Skills: レールを敷く

Claude Code には「Skills」という機能がある。

```
.claude/skills/tdd-init/SKILL.md
.claude/skills/tdd-plan/SKILL.md
.claude/skills/tdd-red/SKILL.md
.claude/skills/tdd-green/SKILL.md
...
```

普通のCLAUDE.mdとの違いは、**フェーズごとに使えるツールを制限できる**こと。

```yaml
---
name: tdd-red
allowed-tools: Read, Write, Glob, Grep, Bash
---
```

REDフェーズでは、テストを書くことしかできない。実装コードに触れるEditツールは使えない。

これが「レール」だ。

## 7フェーズTDD

ait3では「RED → GREEN → REFACTOR」の3フェーズだった。

TDD Skillsでは7フェーズに拡張した。

```
INIT ──→ PLAN ──→ RED ──→ GREEN ──→ REFACTOR ──→ REVIEW ──→ COMMIT
```

なぜ増やしたか。

「RED → GREEN → REFACTOR」だけだと、Claudeは**どこで何をしていいか分からなくなる**。

「今はテストを書くフェーズ？それとも実装？あ、リファクタリングもしていいの？じゃあついでにアーキテクチャも改善しておきますね」

3フェーズでは境界が曖昧すぎた。

7フェーズにすることで、各フェーズの責務が明確になる：

| フェーズ | やること | やってはいけないこと |
|---------|---------|-------------------|
| INIT | サイクル開始宣言 | 計画、テスト、実装 |
| PLAN | 設計・計画 | テスト、実装 |
| RED | 失敗するテスト作成 | 実装コード変更 |
| GREEN | 最小限の実装 | リファクタリング |
| REFACTOR | コード改善 | 新機能追加 |
| REVIEW | 品質チェック | コード変更 |
| COMMIT | git commit | 新しい変更 |

## Skillの実装

例えば、REDフェーズのSkillはこうなっている：

```yaml
---
name: tdd-red
description: REDフェーズ用。失敗するテストを作成する。
allowed-tools: Read, Write, Glob, Grep, Bash
---

# TDD RED Phase

あなたは現在 **REDフェーズ** にいます。

## このフェーズでやること

- [ ] 失敗するテストを書く
- [ ] テストが失敗することを確認する
- [ ] テストが失敗した理由を理解する

## このフェーズで絶対にやってはいけないこと

- 実装コードを書くこと（GREENフェーズで行う）
- リファクタリングすること（REFACTORフェーズで行う）
- テストを通すための最小限以上の変更をすること
```

これを読んだClaudeは、「REDフェーズなので実装は次のフェーズで」と言うようになった。

首輪じゃなくて、レール。

## Cycle Document

もう一つの工夫が「サイクルドキュメント」。

```
docs/cycles/20251210_1200_ユーザーログイン機能.md
```

このファイルに、TDDサイクルの全ての情報を記録する：

- スコープ定義（今回やること、やらないこと）
- テストリスト（TODO、WIP、DONE）
- 実装ノート
- 進捗ログ

Claudeがコンテキストを失っても、このファイルを読めば「あ、今はREDフェーズで、TC-02まで完了していて、TC-03に取り組んでいるところだ」と分かる。

## 実際の使い方

```bash
# 1. プロジェクトにTDD Skillsをインストール
cd your-project
bash /path/to/ClaudeSkills/templates/laravel/install.sh

# 2. Claude Codeを起動
claude

# 3. 機能開発を始める
> ユーザーがパスワードをリセットできるようにしたい
```

Claudeが自動的にTDDサイクルを開始する：

```
================================================================================
INITフェーズを開始します
================================================================================

機能名を「パスワードリセット機能」にしますか？

1. はい
2. 別の名前にする

どうしますか？
```

その後、自動的にPLAN → RED → GREEN → ... と進んでいく。

## ait3との違い

| | ait3 | TDD Skills |
|---|------|------------|
| 形式 | npmパッケージ | Claude Skills |
| 制約方式 | CLAUDE.mdに記述 | フェーズごとにallowed-tools |
| フェーズ数 | 3 | 7 |
| 状態管理 | 外部ファイル | サイクルドキュメント |
| 強制力 | 弱（首輪） | 強（レール） |

## 結論

首輪は抜ける。

でも、レールからは降りにくい。

TDD Skillsは、AIを「信頼して任せる」のではなく「システムで制約する」アプローチだ。

Claudeは賢い。だからこそ、「今回は特別」という言い訳を思いつく。

その言い訳を封じるには、言葉（CLAUDE.md）ではなく、構造（Skills + allowed-tools）で制約するしかない。

---

## リポジトリ

https://github.com/morodomi/tdd-skills

```bash
# 汎用テンプレート
bash /path/to/tdd-skills/templates/generic/install.sh

# Laravel用
bash /path/to/tdd-skills/templates/laravel/install.sh

# Flask用
bash /path/to/tdd-skills/templates/flask/install.sh

# Hugo用
bash /path/to/tdd-skills/templates/hugo/install.sh
```

---

## 関連記事

- [AIの首輪はすぐ抜ける](https://note.com/morodomi/n/n20787aa82620) - 首輪の失敗談
- [私はただの承認ボタンだった](https://note.com/morodomi/n/n3b30c9840417) - AI駆動開発の末路
- [Claudeはこっそり無駄コードを生成し、バレて嘘をついた](https://note.com/morodomi/n/n1ca3c4a25097) - スコープクリープの問題

---

*2025年12月*
