# 企画: Strategic Compact（戦略的コンテキスト圧縮）

## 参考元

[affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) の `skills/strategic-compact/`

## 概要

コンテキスト窓の自動圧縮をワークフローの論理的境界で提案する仕組み。

Claude Code は長いセッションでコンテキスト窓が逼迫すると自動圧縮するが、タイミングが任意のため、作業中の重要な文脈が失われることがある。

参考元ではツール呼び出し数を追跡し、以下のタイミングで圧縮を提案する:

- 設計フェーズ完了後
- デバッグセッション終了後
- 大規模なファイル読み込み後
- テスト実行サイクル完了後

## 現状との比較

| 観点 | 現状 | 参考元 |
|------|------|--------|
| 圧縮タイミング | Claude Code の自動判断 | ワークフロー境界で提案 |
| 状態保存 | なし | PreCompact フックで保存 |
| TDD フェーズ連動 | なし | フェーズ完了時に提案可能 |

## 実装方針

**tdd-core に統合**: TDD の7フェーズが自然な圧縮境界

### 理由

- TDD サイクルの各フェーズ完了が最適な圧縮ポイント
- 独立プラグインにするほどの規模ではない
- tdd-core のスキル間遷移に組み込める

### 適用ポイント

```
INIT → PLAN → [compact] → RED → GREEN → [compact] → REFACTOR → REVIEW → COMMIT
```

| 圧縮タイミング | 理由 |
|---------------|------|
| PLAN 完了後 | 設計情報は Cycle doc に記録済み。以降は実装フェーズ |
| GREEN 完了後 | テストとコードが完成。REFACTOR は差分ベースで十分 |

### 実装イメージ

tdd-plan, tdd-green の SKILL.md 末尾に圧縮ガイダンスを追加:

```markdown
## Phase Completion

このフェーズの成果物:
- [ ] Cycle doc 更新済み
- [ ] 次フェーズの入力情報が Cycle doc に記録済み

上記が確認できたら、コンテキスト圧縮を検討してください。
Cycle doc に全情報が記録されているため、安全に圧縮できます。
```

### PreCompact フックの追加

```json
{
  "PreCompact": [
    {
      "hooks": [{
        "type": "command",
        "command": "scripts/save-tdd-state.sh"
      }]
    }
  ]
}
```

## 検討事項

- Cycle doc が十分な情報を保持しているか（圧縮しても再開できるか）
- 圧縮提案がユーザー体験を阻害しないか（提案頻度の調整）
- redteam-core にも適用すべきか（RECON → SCAN 間など）
- 自動圧縮と手動提案のバランス

## 優先度

低〜中。TDD サイクルの Cycle doc が既にコンテキスト保存の役割を果たしている。圧縮タイミングの最適化は改善ではあるが、現状で致命的な問題は起きていない。
