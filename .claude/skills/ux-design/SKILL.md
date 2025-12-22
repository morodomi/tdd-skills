---
name: ux-design
description: UX心理学とRefactoring UI原則に基づいたUI/UXデザイン支援。AIの統計的デフォルトを禁止し、大胆で独自性のあるデザインを促進。
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# UX Design Skill

AIが統計的に「安全」な選択をすることを防ぎ、**大胆で独自性のある**UI/UXデザインを実現する。

---

## Design Thinking Process

コーディング前に、コンテキストを理解し**大胆な美的方向性**にコミットする。

### 4つの問い

1. **Purpose（目的）**: このインターフェースはどんな問題を解決するか？誰が使うか？
2. **Tone（トーン）**: 極端な美的方向性を1つ選ぶ
   - Brutally Minimal（極限ミニマル）
   - Maximalist Chaos（最大主義的カオス）
   - Retro-Futuristic（レトロフューチャー）
   - Organic（オーガニック）
   - Luxury（ラグジュアリー）
   - Playful（遊び心）
   - Editorial（エディトリアル）
   - Industrial（インダストリアル）
   - Art Deco（アールデコ）
   - Soft（ソフト）
3. **Constraints（制約）**: フレームワーク、パフォーマンス、アクセシビリティ要件
4. **Differentiation（差別化）**: 何がこのUIを忘れられないものにするか？

**原則**: 「明確なコンセプト方向を選び、精度を持って実行する。大胆なマキシマリズムも洗練されたミニマリズムも機能する—重要なのは強度ではなく意図性」

---

## AIスロップ回避（絶対禁止）

以下はAIが統計的に選ぶ「安全」なデフォルト。これらを**絶対に使用しない**。

### フォント禁止リスト

| 禁止 | 理由 |
|------|------|
| Inter, Roboto, Arial | 過剰使用されたAI定番フォント |
| font-family: sans-serif; のみ | 意図のない選択 |
| 全要素16px統一 | 階層構造の欠如 |
| line-height: 1.5 全体統一 | コンテキスト無視 |

**代替**: 独自性のあるディスプレイフォント + 洗練されたボディフォント

```css
/* 良い例: 意図的なフォントペアリング */
:root {
  --font-display: 'Playfair Display', serif;  /* 見出し */
  --font-body: 'Source Sans Pro', sans-serif; /* 本文 */
  --font-mono: 'JetBrains Mono', monospace;   /* コード */
}

h1, h2 { font-family: var(--font-display); line-height: 1.2; }
body { font-family: var(--font-body); line-height: 1.6; }
code { font-family: var(--font-mono); }
```

### カラー禁止リスト

| 禁止 | 理由 |
|------|------|
| #000000（純粋な黒） | 不自然で目が疲れる |
| #FFFFFF（純粋な白） | 同上 |
| 紫グラデーション | AI生成の象徴、クリシェ |
| 均等に分散した控えめなパレット | 印象に残らない |

**代替**: **支配色 + シャープなアクセント**

```css
/* 良い例: 支配色 + アクセント */
:root {
  /* 支配色（メイン） */
  --dominant: hsl(220, 90%, 15%);      /* 深いネイビー */
  --dominant-light: hsl(220, 80%, 95%); /* 背景 */

  /* シャープなアクセント */
  --accent: hsl(45, 100%, 50%);        /* 金色 */
  --accent-muted: hsl(45, 60%, 70%);

  /* ニュアンスのあるグレー */
  --gray-warm: hsl(30, 10%, 40%);
  --gray-cool: hsl(220, 10%, 50%);
}
```

### レイアウト禁止リスト

| 禁止 | 理由 |
|------|------|
| すべて中央揃え | 退屈で予測可能 |
| 均一なカードグリッド | 視覚的単調さ |
| 全要素にボーダー | 視覚的ノイズ |
| 均一なシャドウ（0 4px 6px） | AI定番シャドウ |

**代替**: 非対称・グリッド破壊・余白活用

---

## Typography（タイポグラフィ）

### 原則

- **独自性**: ジェネリックではなく、キャラクターのあるフォントを選ぶ
- **ペアリング**: ディスプレイフォント（見出し）+ ボディフォント（本文）
- **階層**: サイズ・太さ・色で明確な視覚的階層を作る

### 実装ガイド

```css
/* タイプスケール（1.25比率） */
:root {
  --text-xs: 0.75rem;   /* 12px */
  --text-sm: 0.875rem;  /* 14px */
  --text-base: 1rem;    /* 16px */
  --text-lg: 1.25rem;   /* 20px */
  --text-xl: 1.563rem;  /* 25px */
  --text-2xl: 1.953rem; /* 31px */
  --text-3xl: 2.441rem; /* 39px */
  --text-4xl: 3.052rem; /* 49px */
}

/* 階層構造 */
.heading-primary {
  font-size: var(--text-4xl);
  font-weight: 800;
  line-height: 1.1;
  letter-spacing: -0.02em;
  color: var(--gray-900);
}

.body-text {
  font-size: var(--text-base);
  font-weight: 400;
  line-height: 1.7;
  color: var(--gray-700);
}

.caption {
  font-size: var(--text-sm);
  font-weight: 400;
  line-height: 1.4;
  color: var(--gray-500);
}
```

---

## Color & Theme（色彩・テーマ）

### 原則

- **CSS変数で一貫性**: テーマ全体をCSS変数で管理
- **支配色 + アクセント**: 控えめで均等なパレットより効果的
- **HSLベース**: 明度・彩度の調整が容易

### 実装ガイド

```css
:root {
  /* ベースカラー（HSL） */
  --hue-primary: 220;
  --hue-accent: 45;

  /* プライマリカラー（シェード生成） */
  --primary-50: hsl(var(--hue-primary), 90%, 97%);
  --primary-100: hsl(var(--hue-primary), 85%, 92%);
  --primary-500: hsl(var(--hue-primary), 80%, 50%);
  --primary-700: hsl(var(--hue-primary), 75%, 35%);
  --primary-900: hsl(var(--hue-primary), 70%, 15%);

  /* アクセントカラー */
  --accent: hsl(var(--hue-accent), 100%, 50%);
  --accent-hover: hsl(var(--hue-accent), 100%, 45%);

  /* セマンティックカラー */
  --success: hsl(142, 76%, 36%);
  --warning: hsl(38, 92%, 50%);
  --error: hsl(0, 84%, 60%);

  /* ニュアンスグレー（色味を持たせる） */
  --gray-50: hsl(var(--hue-primary), 10%, 98%);
  --gray-100: hsl(var(--hue-primary), 10%, 94%);
  --gray-500: hsl(var(--hue-primary), 8%, 50%);
  --gray-900: hsl(var(--hue-primary), 10%, 10%);
}
```

---

## Motion（モーション）

### 原則

- **目的のあるアニメーション**: 装飾ではなく、意味を伝える
- **CSSファースト**: HTMLではCSS、ReactではMotion/Framer
- **高インパクトな瞬間**: 協調したリビール、マイクロインタラクション

### 実装ガイド

```css
/* トランジション変数 */
:root {
  --ease-out: cubic-bezier(0.33, 1, 0.68, 1);
  --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);

  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
}

/* ボタン：即座のフィードバック */
.btn {
  transition: transform var(--duration-fast) var(--ease-out),
              box-shadow var(--duration-fast) var(--ease-out);
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.btn:active {
  transform: translateY(0) scale(0.98);
}

/* カード：ホバーで浮き上がり */
.card {
  transition: transform var(--duration-normal) var(--ease-spring),
              box-shadow var(--duration-normal) var(--ease-out);
}

.card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
}

/* フェードイン（スクロール表示用） */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation: fadeInUp var(--duration-slow) var(--ease-out) forwards;
}

/* スタガード表示（リストアイテム） */
.list-item:nth-child(1) { animation-delay: 0ms; }
.list-item:nth-child(2) { animation-delay: 100ms; }
.list-item:nth-child(3) { animation-delay: 200ms; }
.list-item:nth-child(4) { animation-delay: 300ms; }

/* ローディング：400ms後に表示（Doherty Threshold） */
.loading-indicator {
  opacity: 0;
  animation: fadeIn 300ms ease-in 400ms forwards;
}
```

---

## Spatial Composition（空間構成）

### 原則

- **予期しないレイアウト**: 標準グリッドを超える
- **非対称**: 完璧な対称を避け、視覚的緊張を作る
- **オーバーラップ**: 要素を重ねて深度を作る
- **余白の両極**: 広大なネガティブスペース or 制御された密度

### 実装ガイド

```css
/* スペーシングスケール */
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
  --space-12: 48px;
  --space-16: 64px;
  --space-24: 96px;
  --space-32: 128px;
}

/* 非対称レイアウト */
.hero {
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  gap: var(--space-12);
  align-items: end; /* 下揃えで非対称感 */
}

/* オーバーラップ */
.card-featured {
  position: relative;
  margin-top: calc(var(--space-8) * -1); /* 上のセクションに重ねる */
  z-index: 10;
}

/* 対角線フロー */
.diagonal-section {
  transform: skewY(-3deg);
  margin: var(--space-16) 0;
}

.diagonal-section > * {
  transform: skewY(3deg); /* 中身は戻す */
}

/* グリッド破壊：一部を大きく */
.masonry-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--space-4);
}

.masonry-grid .featured {
  grid-column: span 2;
  grid-row: span 2;
}
```

---

## Backgrounds & Details（背景・詳細）

### 原則

- **雰囲気を作る**: 平坦な背景ではなく、視覚的な深みを
- **レイヤー**: 複数のビジュアルレイヤーで奥行きを
- **質感**: ノイズ、グレイン、テクスチャで生命感を

### 実装ガイド

```css
/* グラデーションメッシュ */
.bg-mesh {
  background:
    radial-gradient(at 20% 80%, hsl(220, 80%, 70%) 0%, transparent 50%),
    radial-gradient(at 80% 20%, hsl(280, 80%, 70%) 0%, transparent 50%),
    radial-gradient(at 50% 50%, hsl(180, 80%, 85%) 0%, transparent 70%),
    hsl(220, 30%, 98%);
}

/* ノイズテクスチャオーバーレイ */
.noise-overlay::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  opacity: 0.03;
  pointer-events: none;
}

/* グレインエフェクト */
.grain {
  position: relative;
}

.grain::after {
  content: '';
  position: absolute;
  inset: 0;
  background: url('/grain.png');
  opacity: 0.08;
  mix-blend-mode: overlay;
  pointer-events: none;
}

/* ドラマチックシャドウ */
.dramatic-shadow {
  box-shadow:
    0 4px 6px rgba(0, 0, 0, 0.07),
    0 10px 20px rgba(0, 0, 0, 0.1),
    0 30px 60px rgba(0, 0, 0, 0.15);
}

/* グラスモーフィズム */
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

/* 幾何学パターン */
.geometric-bg {
  background-image:
    linear-gradient(30deg, var(--primary-100) 12%, transparent 12.5%),
    linear-gradient(150deg, var(--primary-100) 12%, transparent 12.5%),
    linear-gradient(210deg, var(--primary-100) 12%, transparent 12.5%),
    linear-gradient(330deg, var(--primary-100) 12%, transparent 12.5%);
  background-size: 80px 140px;
}
```

---

## UX心理学原則

### 認知負荷削減（Cognitive Load）

人間の作業記憶は限られている（7±2項目）。

```html
<!-- ステップ分割でフォームの認知負荷を削減 -->
<form class="multi-step">
  <div class="progress">
    <span class="step active">1</span>
    <span class="step">2</span>
    <span class="step">3</span>
  </div>
  <div class="step-content">
    <h3>まず、お名前を教えてください</h3>
    <input name="name" autofocus>
  </div>
</form>
```

### ドハティの閾値（Doherty Threshold）

システム応答は400ms以内で。超える場合はフィードバック必須。

### 損失回避（Loss Aversion）

人は利益より損失を重視する。

```html
<!-- 損失を強調したCTA -->
<div class="cta-section">
  <button class="cta-primary">今すぐ始める</button>
  <p class="urgency">残り3日で30%オフ終了</p>
</div>

<!-- 退会防止 -->
<div class="cancel-warning">
  <h3>退会すると失われるもの</h3>
  <ul>
    <li>保存した47件のプロジェクト</li>
    <li>1,200分の作業履歴</li>
  </ul>
</div>
```

### 希少性の原理（Scarcity）

限定されたものほど価値が高く感じる。

```html
<div class="scarcity-indicator">
  <span class="stock warning">残り3個</span>
  <span class="viewers">12人が閲覧中</span>
</div>
```

### 社会的証明（Social Proof）

他者の行動が判断基準となる。

```html
<div class="social-proof">
  <div class="avatar-stack">
    <img src="user1.jpg" alt="">
    <img src="user2.jpg" alt="">
    <img src="user3.jpg" alt="">
    <span>+2,847人が登録</span>
  </div>
</div>
```

### ツァイガルニク効果（Zeigarnik Effect）

未完了タスクは記憶に残る。

```html
<div class="profile-completion">
  <div class="progress-ring" style="--progress: 65"></div>
  <p>プロフィール完成度: 65%</p>
  <ul class="remaining-tasks">
    <li>プロフィール写真を追加</li>
    <li>自己紹介を記入</li>
  </ul>
</div>
```

### 目標勾配効果（Goal Gradient）

ゴールに近づくほどモチベーションが上がる。

```html
<div class="points-progress">
  <p>あと<strong>200ポイント</strong>で特典獲得！</p>
  <div class="progress-bar">
    <div class="fill" style="width: 80%"></div>
  </div>
</div>
```

---

## 実装複雑度の原則

**美的ビジョンに実装複雑度を合わせる**

| 方向性 | 実装アプローチ |
|--------|---------------|
| マキシマリスト | 精巧なコード、広範なアニメーション、複雑なレイヤー |
| ミニマリスト | 抑制と精度、スペーシングとタイポグラフィへの細心の注意 |

---

## 実装前チェックリスト

### Design Thinking

- [ ] Purpose（目的）を明確に定義したか
- [ ] Tone（トーン）を1つ選んでコミットしたか
- [ ] Constraints（制約）を確認したか
- [ ] Differentiation（差別化ポイント）を特定したか

### AIスロップ回避

- [ ] 禁止フォント（Inter, Roboto, Arial単体）を使っていないか
- [ ] 純粋な黒/白を使っていないか
- [ ] 紫グラデーションを使っていないか
- [ ] 均一なカードグリッドのみになっていないか
- [ ] 全要素が中央揃えになっていないか

### Typography

- [ ] 意図的なフォントペアリングをしているか
- [ ] 明確な視覚的階層（サイズ・太さ・色）があるか

### Color & Theme

- [ ] CSS変数でテーマを管理しているか
- [ ] 支配色 + アクセントの構成か
- [ ] グレーに色味を持たせているか

### Motion

- [ ] ボタン・カードにホバー/クリックフィードバックがあるか
- [ ] 400ms超の処理にローディング表示があるか
- [ ] アニメーションに目的があるか

### Spatial Composition

- [ ] 一貫したスペーシングスケールを使用しているか
- [ ] 非対称やグリッド破壊を検討したか
- [ ] ボーダーより背景色・余白で区切っているか

### Backgrounds & Details

- [ ] 平坦な背景ではなく雰囲気を作っているか
- [ ] 必要に応じてテクスチャ・グレインを使用しているか

### UX心理学

- [ ] CTAに損失回避/希少性を適用したか
- [ ] フォームの認知負荷を削減したか
- [ ] 社会的証明を配置したか
- [ ] 進捗表示にゴール勾配効果を活用したか

### アクセシビリティ

- [ ] コントラスト比がWCAG基準を満たしているか（本文4.5:1以上）
- [ ] フォーカス状態が明確か
- [ ] 色だけに依存していないか（アイコン・テキスト併用）

---

## 参考リソース

- [Anthropic Frontend Design Skill](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design)
- [Refactoring UI](https://www.refactoringui.com/)
- [Laws of UX](https://lawsofux.com/)
- [松下村塾 UX心理学45原則](https://www.shokasonjuku.com/ux-psychology)

---

*このSkillはClaudeSkillsプロジェクトの一部です*
