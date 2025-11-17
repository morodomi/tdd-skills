---
name: ux-design
description: UX心理学とRefactoring UI原則に基づいたUI/UXデザイン支援。AIの統計的デフォルトを禁止し、効果的なデザインを促進。
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# UX Design Skill

AIが統計的に「安全」な選択をすることを防ぎ、UX心理学とRefactoring UI原則に基づいた効果的なUI/UXデザインを実現する。

---

## 禁止パターン（絶対に避けるべきこと）

以下のパターンは、AIが統計的に選びがちな「安全」なデフォルトです。これらを明示的に禁止します。

### フォント禁止

❌ **禁止**: システムデフォルトフォントのみ使用
❌ **禁止**: font-family: sans-serif; のみ指定
❌ **禁止**: フォントサイズを16pxで統一
❌ **禁止**: line-heightを1.5で全体統一

**代替案**:
- Inter, Noto Sans JP等の意図的なフォント選定
- 見出し/本文/キャプションで異なるフォントサイズ（階層構造）
- line-height: 見出し1.2、本文1.6-1.8、キャプション1.4

### カラー禁止

❌ **禁止**: 純粋な黒（#000000）をテキストに使用
❌ **禁止**: 純粋な白（#FFFFFF）を背景に使用
❌ **禁止**: 彩度100%の原色をそのまま使用
❌ **禁止**: グレーにHSLでの色味を持たせない

**代替案**:
- テキスト: #1a1a1a〜#2d2d2d（ソフトブラック）
- 背景: #fafafa〜#f5f5f5（オフホワイト）
- アクセント色: HSLでS値を60-80%に調整
- グレー: HSL(220, 10%, 40%) のように青みを持たせる

### UIパターン禁止

❌ **禁止**: 「Submit」「送信」などの汎用ボタンラベル
❌ **禁止**: すべてのボタンを同じサイズ・色で統一
❌ **禁止**: フォームエラーを赤色テキストのみで表示
❌ **禁止**: ローディング時に何も表示しない
❌ **禁止**: 確認モーダルで「OK」「キャンセル」

**代替案**:
- 「アカウントを作成」「変更を保存」等の行動指向ラベル
- プライマリ/セカンダリ/ターシャリの視覚的階層
- エラー: アイコン + 色 + 具体的なメッセージ
- ローディング: スケルトン or プログレスインジケータ
- 「削除する」「キャンセル」等の具体的なアクションラベル

### レイアウト禁止

❌ **禁止**: すべての要素にボーダーを追加
❌ **禁止**: 余白を8px固定
❌ **禁止**: コンテンツを中央揃えのみ
❌ **禁止**: カード全体に均一なシャドウ

**代替案**:
- ボーダーの代わりに背景色・余白で区切る
- 8/16/24/32/48pxの一貫したスペーシングスケール
- 左揃え基本、中央揃えは意図的な場合のみ
- シャドウは小さく、下方向のみ（y: 2-4px）

---

## UX心理学原則（適用ガイド）

### 1. アンカー効果（Anchoring）

最初に提示された情報が判断基準となる。

**適用場面**: 料金表、商品比較
**実装例**:
```html
<!-- 料金表：最高プランを最初に表示 -->
<div class="pricing">
  <div class="plan featured">
    <div class="price">¥9,800/月</div>
    <div class="name">プロフェッショナル</div>
  </div>
  <div class="plan">
    <div class="price">¥2,980/月</div>
    <div class="name">スタンダード</div>
  </div>
</div>
```

### 2. 認知負荷削減（Cognitive Load）

人間の作業記憶は限られている（7±2項目）。

**適用場面**: フォーム設計、ナビゲーション
**実装例**:
```html
<!-- フォーム：ステップ分割で認知負荷を削減 -->
<form>
  <div class="step active">
    <h3>Step 1 of 3: 基本情報</h3>
    <input name="name" placeholder="お名前">
    <input name="email" placeholder="メールアドレス">
  </div>
  <!-- 次のステップは非表示 -->
</form>
```

### 3. ドハティの閾値（Doherty Threshold）

システム応答は400ms以内で。それを超える場合はフィードバック必須。

**適用場面**: ボタンクリック、データ取得
**実装例**:
```css
/* ボタン：即座のフィードバック */
.btn:active {
  transform: scale(0.98);
  transition: transform 0.1s;
}

/* ローディング：400ms後に表示 */
.loading {
  animation: fadeIn 0.3s ease-in 0.4s forwards;
  opacity: 0;
}
```

### 4. 社会的証明（Social Proof）

他者の行動が判断基準となる。

**適用場面**: 商品ページ、サインアップ
**実装例**:
```html
<div class="social-proof">
  <div class="avatars">
    <img src="user1.jpg">
    <img src="user2.jpg">
    <img src="user3.jpg">
    <span>+2,847人が登録</span>
  </div>
  <div class="testimonial">
    "このツールで作業時間が50%削減できました" - 田中様
  </div>
</div>
```

### 5. 損失回避（Loss Aversion）

人は利益を得ることより損失を避けることを重視する。

**適用場面**: CTA、退会防止
**実装例**:
```html
<!-- CTA：損失を強調 -->
<button class="cta">
  今すぐ始める
  <span class="urgency">残り3日で割引終了</span>
</button>

<!-- 退会防止 -->
<div class="cancel-warning">
  <h3>退会すると失われるもの</h3>
  <ul>
    <li>保存した47件のプロジェクト</li>
    <li>1,200分の作業履歴</li>
    <li>特別会員限定の機能</li>
  </ul>
</div>
```

### 6. ナッジ効果（Nudge）

選択肢のデフォルト設定が行動を誘導する。

**適用場面**: 設定画面、チェックボックス
**実装例**:
```html
<!-- 推奨オプションをデフォルトON -->
<label>
  <input type="checkbox" checked>
  週次レポートを受け取る（推奨）
</label>

<!-- 料金表：推奨プランを強調 -->
<div class="plan recommended">
  <div class="badge">おすすめ</div>
  <!-- ... -->
</div>
```

### 7. 段階的要請（Foot-in-the-Door）

小さな要求から始めて、徐々に大きな要求へ。

**適用場面**: オンボーディング、アップセル
**実装例**:
```html
<!-- オンボーディング：段階的に情報収集 -->
<div class="onboarding">
  <div class="step-1">
    <p>まず、お名前を教えてください</p>
    <input name="name">
  </div>
  <!-- 完了後に次のステップ -->
</div>
```

### 8. ツァイガルニク効果（Zeigarnik Effect）

未完了のタスクは完了したものより記憶に残る。

**適用場面**: プロフィール完成度、チュートリアル
**実装例**:
```html
<div class="profile-completion">
  <div class="progress-bar" style="width: 65%"></div>
  <p>プロフィール完成度: 65%</p>
  <ul class="remaining">
    <li>プロフィール写真を追加</li>
    <li>自己紹介を記入</li>
  </ul>
</div>
```

### 9. 変動型報酬（Variable Rewards）

予測不能な報酬が最もエンゲージメントを高める。

**適用場面**: 通知、ゲーミフィケーション
**実装例**:
```html
<!-- 通知バッジ：数値表示で期待感 -->
<div class="notification-bell">
  <span class="badge">3</span>
</div>

<!-- 達成バッジ：ランダム要素 -->
<div class="achievement">
  新しいバッジを獲得しました！
  <div class="badge-reveal">???</div>
</div>
```

### 10. フレーミング効果（Framing Effect）

同じ情報でも表現方法で印象が変わる。

**適用場面**: 統計表示、価格表示
**実装例**:
```html
<!-- ポジティブフレーミング -->
<p>95%のユーザーが満足</p>
<!-- vs ネガティブ: 5%が不満 -->

<!-- 価格フレーミング -->
<p>1日あたりたったの¥99</p>
<!-- vs: 月額¥2,980 -->
```

### 11. 希少性の原理（Scarcity）

限定されたものほど価値が高く感じる。

**適用場面**: 在庫表示、期間限定
**実装例**:
```html
<div class="scarcity">
  <span class="stock">残り3個</span>
  <span class="viewers">現在12人が閲覧中</span>
</div>
```

### 12. デフォルト効果（Default Effect）

人はデフォルト設定を変更しない傾向がある。

**適用場面**: プラン選択、オプション設定
**実装例**:
```html
<!-- 中間プランをデフォルト選択 -->
<div class="plans">
  <div class="plan">ベーシック</div>
  <div class="plan selected">スタンダード</div>
  <div class="plan">プレミアム</div>
</div>
```

### 13. 目標勾配効果（Goal Gradient）

ゴールに近づくほどモチベーションが上がる。

**適用場面**: ポイント、進捗表示
**実装例**:
```html
<div class="points-progress">
  <p>あと200ポイントで特典獲得！</p>
  <div class="bar" style="width: 80%">
    <span>800/1000</span>
  </div>
</div>
```

---

## Refactoring UI原則

### 階層構造（Visual Hierarchy）

重要度に応じて視覚的な重みを与える。

**実装ルール**:
- フォントサイズ: 見出し > 本文 > キャプション（1.25-1.5倍の比率）
- 色の濃さ: 重要な情報ほど濃く
- 太さ: 重要なものはbold、補足はnormal

```css
.heading { font-size: 24px; font-weight: 700; color: #1a1a1a; }
.body { font-size: 16px; font-weight: 400; color: #4a4a4a; }
.caption { font-size: 12px; font-weight: 400; color: #6a6a6a; }
```

### ボーダー削減（Less Borders）

ボーダーに頼らず、余白と背景色で区切る。

**実装ルール**:
- カード: ボーダーではなく背景色 + シャドウ
- セクション: 余白で区切る
- 区切り線: 必要最小限（テーブルヘッダーなど）

```css
/* 悪い例 */
.card { border: 1px solid #ccc; }

/* 良い例 */
.card {
  background: #fff;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12);
}
```

### スペーシング（Spacing System）

一貫したスペーシングスケールを使用。

**実装ルール**:
- 基本単位: 4px または 8px
- スケール: 4, 8, 16, 24, 32, 48, 64px
- 関連要素は近く、無関連は遠く

```css
:root {
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;
  --space-2xl: 48px;
}
```

### タイポグラフィ（Typography）

フォントの選定と一貫した使用。

**実装ルール**:
- 本文フォント: 読みやすさ優先（Noto Sans JP, Inter）
- 見出しフォント: 個性（必要に応じて）
- 数字: 等幅フォント（tabular-nums）

```css
body {
  font-family: 'Noto Sans JP', sans-serif;
  font-feature-settings: 'palt';
}

.price {
  font-variant-numeric: tabular-nums;
}
```

### 色彩管理（HSL Color Management）

HSLで色を管理し、シェードを生成。

**実装ルール**:
- ベース色をHSLで定義
- 明度を調整してシェード生成
- グレーにも微妙な色味を

```css
:root {
  /* ブランドカラー */
  --primary-h: 220;
  --primary-s: 90%;
  --primary: hsl(var(--primary-h), var(--primary-s), 50%);
  --primary-light: hsl(var(--primary-h), var(--primary-s), 70%);
  --primary-dark: hsl(var(--primary-h), var(--primary-s), 30%);

  /* 色味のあるグレー */
  --gray-100: hsl(220, 10%, 95%);
  --gray-500: hsl(220, 10%, 50%);
  --gray-900: hsl(220, 10%, 15%);
}
```

### グレースケールデザイン

まずグレースケールでデザインし、後から色を追加。

**実装ルール**:
- 最初は色を使わず、明度のみで階層を作る
- 階層が明確になったら色を追加
- 色は強調したい部分のみ

### コントラスト確保

WCAG基準を満たすコントラスト比。

**実装ルール**:
- 本文テキスト: 4.5:1以上
- 大きな文字: 3:1以上
- 背景とのコントラストを常に確認

---

## UIコンポーネント設計例

### CTAボタン（Call to Action）

```html
<button class="cta-primary">
  <span class="label">無料で始める</span>
  <span class="subtext">クレジットカード不要</span>
</button>
```

```css
.cta-primary {
  background: hsl(220, 90%, 50%);
  color: white;
  padding: 16px 32px;
  border-radius: 8px;
  font-weight: 600;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.cta-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.cta-primary:active {
  transform: translateY(0);
}

.cta-primary .subtext {
  display: block;
  font-size: 12px;
  font-weight: 400;
  opacity: 0.9;
  margin-top: 4px;
}
```

### 料金表（Pricing Table）

```html
<div class="pricing-table">
  <div class="plan">
    <div class="plan-name">スターター</div>
    <div class="plan-price">
      <span class="amount">¥980</span>
      <span class="period">/月</span>
    </div>
    <ul class="features">
      <li>機能A</li>
      <li>機能B</li>
      <li class="unavailable">機能C</li>
    </ul>
    <button class="plan-cta">選択する</button>
  </div>

  <div class="plan featured">
    <div class="badge">人気</div>
    <div class="plan-name">プロ</div>
    <div class="plan-price">
      <span class="amount">¥2,980</span>
      <span class="period">/月</span>
    </div>
    <ul class="features">
      <li>機能A</li>
      <li>機能B</li>
      <li>機能C</li>
    </ul>
    <button class="plan-cta primary">選択する</button>
  </div>
</div>
```

### フォーム入力（Form Input）

```html
<div class="form-field">
  <label for="email">メールアドレス</label>
  <div class="input-wrapper">
    <input
      type="email"
      id="email"
      placeholder="example@mail.com"
      aria-describedby="email-hint"
    >
    <span class="icon-valid">✓</span>
  </div>
  <p id="email-hint" class="hint">仕事用メールアドレスを推奨します</p>
</div>

<div class="form-field error">
  <label for="password">パスワード</label>
  <input type="password" id="password">
  <p class="error-message">
    <span class="icon">⚠</span>
    8文字以上で入力してください（現在: 5文字）
  </p>
</div>
```

### ローディング状態

```html
<!-- スケルトンローダー -->
<div class="card skeleton">
  <div class="skeleton-image"></div>
  <div class="skeleton-text"></div>
  <div class="skeleton-text short"></div>
</div>

<!-- プログレスインジケータ -->
<div class="loading-overlay">
  <div class="spinner"></div>
  <p>データを読み込み中...</p>
  <p class="progress">3/10 件処理完了</p>
</div>
```

---

## 実装前チェックリスト

### 基本確認

- [ ] ターゲットユーザーのペルソナを定義したか
- [ ] 主要なユーザーフローを洗い出したか
- [ ] 競合サービスのUIを調査したか
- [ ] アクセシビリティ要件を確認したか

### 禁止パターン確認

- [ ] 汎用的なボタンラベルを使っていないか
- [ ] 純粋な黒/白を使っていないか
- [ ] システムデフォルトフォントのみになっていないか
- [ ] すべてのボーダーが必要か確認したか
- [ ] エラー表示が色のみに依存していないか

### UX心理学適用確認

- [ ] CTAに損失回避/希少性を適用したか
- [ ] フォームの認知負荷を削減したか
- [ ] ローディング時間が400ms超の場合フィードバックがあるか
- [ ] 社会的証明（レビュー、利用者数）を配置したか
- [ ] 進捗表示にツァイガルニク効果を活用したか

### Refactoring UI確認

- [ ] 視覚的階層が明確か（サイズ、色、太さ）
- [ ] スペーシングが一貫しているか
- [ ] 不要なボーダーを削除したか
- [ ] 色彩がHSLベースで管理されているか
- [ ] コントラスト比がWCAG基準を満たしているか

### コンポーネント確認

- [ ] ボタンに明確なフィードバック（hover/active）があるか
- [ ] フォームエラーが具体的で対処法を示しているか
- [ ] ローディング状態が適切に表示されるか
- [ ] モバイル対応を考慮しているか

---

## 参考リソース

- [松下村塾 UX心理学45原則](https://www.shokasonjuku.com/ux-psychology)
- [Refactoring UI](https://www.refactoringui.com/)
- [izanami.dev 禁止パターン方式](https://izanami.dev/post/e84bbd32-cc13-46d2-9b62-b2aef12e6564)
- [Laws of UX](https://lawsofux.com/)
